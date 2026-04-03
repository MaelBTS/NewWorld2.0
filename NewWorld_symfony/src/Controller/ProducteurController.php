<?php

namespace App\Controller;
use App\Entity\ArchiveProducteur;
use App\Entity\Producteur;
use App\Form\ProducteurType;
use DateTimeImmutable;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Symfony\Component\Security\Core\Security;

class ProducteurController extends AbstractController
{
    #[Route('/producteur/dashboard', name: 'app_producteur_dashboard')]
    public function index(Request $request, EntityManagerInterface $em, UserPasswordHasherInterface $passwordHasher): Response
    {
        $user = $this->getUser();
        if (!$user) return $this->redirectToRoute('app_login');

        // On lie le producteur via l'email de l'utilisateur connecté
        $producteur = $em->getRepository(Producteur::class)->findOneBy(['email' => $user->getUserIdentifier()]);

        if (!$producteur) {
            $this->addFlash('error', 'Profil introuvable.');
            return $this->redirectToRoute('app_login');
        }

        $form = $this->createForm(ProducteurType::class, $producteur);
        // On rend le mot de passe non-obligatoire en modification
        $form->add('plainPassword', \Symfony\Component\Form\Extension\Core\Type\PasswordType::class, [
            'label' => 'MODIFIER LE MOT DE PASSE (OPTIONNEL)',
            'required' => false,
            'mapped' => true,
            'attr' => ['placeholder' => 'Laisser vide pour ne pas changer']
        ]);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Hachage du mot de passe si rempli
            $plainPassword = $form->get('plainPassword')->getData();
            if ($plainPassword) {
                $user->setPassword($passwordHasher->hashPassword($user, $plainPassword));
            }

            $em->flush();

            // L'ALERTE DE SUCCÈS
            $this->addFlash('success', '✅ Vos modifications ont été enregistrées avec succès !');

            return $this->redirectToRoute('app_producteur_dashboard');
        }

        return $this->render('producteur/index.html.twig', [
            'form' => $form->createView(),
            'producteur' => $producteur
        ]);
    }

    #[Route('/producteur/delete-account', name: 'app_producteur_self_delete', methods: ['POST'])]
    public function delete(
        EntityManagerInterface $em,
        Request $request,
        TokenStorageInterface $tokenStorage
    ): Response {
        $user = $this->getUser();

        if ($user) {
            // 1. Delete all Producteur with the same email
            $producteurs = $em->getRepository(Producteur::class)
                ->findBy(['email' => $user->getUserIdentifier()]);

            foreach ($producteurs as $producteur) {
                $archives = new ArchiveProducteur();
                $archives->setAncienId($producteur->getId());
                $archives->setData([
                    "nom" => $producteur->getNom(), 
                    "email" => $producteur->getEmail(), 
                    "adresse" => $producteur->getAdresse(), 
                    "code_postal" => $producteur->getCodePostal(), 
                    "ville" => $producteur->getVille(), 
                    "telephone" => $producteur->getTelephone(), 
                    "numero_siret" => $producteur->getNumeroSiret()
                ]);
                $archives->setDateArchivage(new DateTimeImmutable());
                $em->persist($archives);
                $em->remove($producteur);
            }

            // 2. Remove the user
            $em->remove($user);
            $em->flush();

            // 3. Clear the token and invalidate session (avoid refresh error)
            $tokenStorage->setToken(null);
            $request->getSession()->invalidate();
        }

        $this->addFlash('success', 'Compte supprimé avec succès.');

        return $this->redirectToRoute('app_login');
    }
}