<?php

namespace App\Controller;

use App\Entity\Producteur;
use App\Entity\User;
use App\Entity\Users;
use App\Form\ProducteurType;
use App\Repository\ProducteurRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[Route('/secretaire')]
class SecretaireController extends AbstractController
{
    #[Route('/', name: 'app_secretaire_dashboard', methods: ['GET', 'POST'])]
    public function index(
        ProducteurRepository $repo, 
        Request $request, 
        EntityManagerInterface $em,
        UserPasswordHasherInterface $passwordHasher
    ): Response {
        
        $producteurs = $repo->findAll();
        
        // On récupère les paramètres de l'URL
        $editId = $request->query->get('edit');
        $isNew = $request->query->has('new'); // Pour le bouton "Ajouter"
        $formView = null;

        if ($isNew || $editId) {
            $producteur = $isNew ? new Producteur() : $repo->find($editId);
            
            if ($producteur) {
                $form = $this->createForm(ProducteurType::class, $producteur);
                $form->handleRequest($request);

                if ($form->isSubmitted() && $form->isValid()) {
                    
                    // LOGIQUE CRÉATION USER (uniquement si c'est un nouveau producteur)
                    if ($isNew) {
                        $user = new Users();
                        $user->setEmail($producteur->getEmail());
                        $user->setRoles(['ROLE_PRODUCTEUR']);
                        
                        // On récupère le mot de passe du champ 'motDePasse' du formulaire
                        $plainPassword = $form->get('plainPassword')->getData();
                        if ($plainPassword) {
                            $user->setPassword($passwordHasher->hashPassword($user, $plainPassword));
                            $em->persist($user);
                        }
                    }

                    $em->persist($producteur);
                    $em->flush();

                    $this->addFlash('success', $isNew ? 'Producteur et compte créés !' : 'Modifications enregistrées.');
                    return $this->redirectToRoute('app_secretaire_dashboard');
                }
                $formView = $form->createView();
            }
        }

        return $this->render('secretaire/secre.html.twig', [
            'producteurs' => $producteurs,
            'form' => $formView,
            'editId' => $editId
        ]);
    }
}