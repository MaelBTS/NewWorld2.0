<?php

namespace App\Controller;

use App\Entity\ArchiveProducteur;
use App\Entity\Audit;
use App\Entity\Demandes;
use App\Entity\Producteur;
use App\Entity\Secretaire;
use App\Entity\Users;
use App\Form\ProducteurType;
use App\Form\SecretaireType;
use App\Repository\AuditRepository;
use App\Repository\DemandesRepository;
use App\Repository\ProducteurRepository;
use App\Repository\SecretaireRepository;
use DateTimeImmutable;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[Route('/admin')]
class AdminController extends AbstractController
{
    #[Route('/dashboard', name: 'app_admin_dashboard', methods: ['GET', 'POST'])]
    public function index(
        ProducteurRepository $pRep, 
        SecretaireRepository $sRep, 
        DemandesRepository $dRep,
        AuditRepository $aRep,
        Request $request, 
        EntityManagerInterface $em,
        UserPasswordHasherInterface $passwordHasher
    ): Response {
        
        $type = $request->get('type'); 
        $editId = $request->get('edit');
        $isNew = $request->get('new');
        $formView = null;

        if ($type) {
            $class = ($type === 'sec') ? Secretaire::class : Producteur::class;
            $fType = ($type === 'sec') ? SecretaireType::class : ProducteurType::class;
            
            $entity = ($editId) ? $em->getRepository($class)->find($editId) : new $class();
            
            if ($entity) {
                $form = $this->createForm($fType, $entity);
                $form->handleRequest($request);

                if ($form->isSubmitted() && $form->isValid()) {
                    // --- Gestion de l'entité Users (Compte de connexion) ---
                    // On cherche si un utilisateur existe déjà avec cet email
                    $user = $em->getRepository(Users::class)->findOneBy(['email' => $entity->getEmail()]);
                    
                    if (!$user) {
                        $user = new Users();
                    }

                    $user->setEmail($entity->getEmail());
                    
                    // Définition du rôle selon le type
                    $role = ($type === 'sec') ? 'ROLE_SECRETAIRE' : 'ROLE_PRODUCTEUR';
                    $user->setRoles([$role]);

                    // Hashage du mot de passe s'il est renseigné
                    $plainPassword = $form->get('plainPassword')->getData();
                    if ($plainPassword) {
                        $user->setPassword($passwordHasher->hashPassword($user, $plainPassword));
                    }

                    if (!$user->getId()) {
                        $em->persist($user);
                    }
                    
                    $em->persist($entity);
                    $em->flush();
                    
                    $this->addFlash('success', 'Enregistrement réussi !');
                    return $this->redirectToRoute('app_admin_dashboard', ['tab' => $type]);
                }
                $formView = $form->createView();
            }
        }

        return $this->render('admin/admin.html.twig', [
            'producteurs' => $pRep->findAll(),
            'secretaires' => $sRep->findAll(),
            'demandes' => $dRep->findAll(),
            'audits' => $aRep->findAll(),
            'form' => $formView,
            'type' => $type,
            'isNew' => $isNew,
            'activeTab' => $request->query->get('tab', $type ?? 'prod')
        ]);
    }

    #[Route('/resilier-producteur/{id}', name: 'app_admin_resilier_producteur', methods: ['POST'])]
    public function terminatePartnership(Producteur $producteur, EntityManagerInterface $em): Response
    {
        $now = new \DateTime();
        $dateCreation = $producteur->getDateCreation();
        
        $nextAnniversary = clone $dateCreation;
        $nextAnniversary->setDate((int)$now->format('Y'), (int)$dateCreation->format('m'), (int)$dateCreation->format('d'));

        if ($nextAnniversary < $now) {
            $nextAnniversary->modify('+1 year');
        }

        $diff = $now->diff($nextAnniversary);
        $monthsUntilAnniversary = ($diff->y * 12) + $diff->m;

        if ($monthsUntilAnniversary < 6) {
            $nextAnniversary->modify('+1 year');
        }

        $producteur->setDeleteAt($nextAnniversary);
        $producteur->setStatut('Résiliation programmée');
        
        $em->flush();

        $this->addFlash('success', sprintf('Le partenariat avec %s sera résilié le %s (préavis respecté).', $producteur->getNom(), $nextAnniversary->format('d/m/Y')));

        return $this->redirectToRoute('app_admin_dashboard', ['tab' => 'prod']);
    }

    #[Route('/delete/{type}/{id}', name: 'app_admin_delete', methods: ['POST', 'GET'])]
    public function delete(string $type, int $id, EntityManagerInterface $em): Response
    {
        $class = ($type === 'sec')
            ? Secretaire::class
            : ($type === 'prod'
                ? Producteur::class
                : ($type === 'demandes'
                    ? Demandes::class
                    : Audit::class));

        $entity = $em->getRepository($class)->find($id);

        if ($entity) {
            if ($type === 'audits') {
                /** @var Audit $entity */
                $producteur = $entity->getProducteur();
                if ($producteur) {
                    $user = $em->getRepository(Users::class)->findOneBy(['email' => $producteur->getEmail()]);
                    if ($user) { $em->remove($user); }
                    $em->remove($producteur); 
                }
            } elseif ($type === 'prod' || $type === 'sec') {
                // Pour prod et sec, on cherche l'utilisateur par l'email de l'entité
                $user = $em->getRepository(Users::class)->findOneBy(['email' => $entity->getEmail()]);
                if ($user) {
                    $em->remove($user);
                }
            } elseif ($type === 'demandes') {
                // Pas de compte Users pour une demande non validée
            }

            $em->remove($entity);
            $em->flush();

            $type === 'demandes'
                ? $this->addFlash('success', 'Refusé avec succès.')
                : $this->addFlash('success', 'Supprimé avec succès.');
        }

        return $this->redirectToRoute('app_admin_dashboard', ['tab' => $type]);
    }

    #[Route('/valider-demande/{id}', name: 'app_admin_valider_demande', methods: ['POST'])]
    public function validerDemande(
        Demandes $demande,
        EntityManagerInterface $em,
        UserPasswordHasherInterface $passwordHasher,
        Request $request
    ): Response {
        if (!$this->isCsrfTokenValid('valider_demande' . $demande->getId(), $request->request->get('_token'))) {
            $this->addFlash('success', 'Token CSRF invalide.');
            return $this->redirectToRoute('app_admin_dashboard', ['tab' => 'demandes']);
        }

        $producteur = new Producteur();
        $producteur->setNom($demande->getNom());
        $producteur->setAdresse($demande->getAdresse());
        $producteur->setVille($demande->getVille());
        $producteur->setCodePostal($demande->getCodePostal());
        $producteur->setEmail($demande->getEmail());
        $producteur->setTelephone($demande->getTelephone());
        $producteur->setNumeroSiret($demande->getNumeroSiret());
        $producteur->setStatut('En audit');
        $producteur->setDateCreation(new \DateTime());

        $user = new Users();
        $user->setEmail($producteur->getEmail());
        $user->setRoles(['ROLE_PRODUCTEUR']);
        $plainPassword = bin2hex(random_bytes(4)); 
        $user->setPassword($passwordHasher->hashPassword($user, $plainPassword));

        $em->persist($user);
        $em->persist($producteur);

        $audit = new Audit();
        $audit->setProducteur($producteur);
        $audit->setDateAudit(new \DateTimeImmutable());
        $audit->setResultat('En cours');
        $audit->setCommentaire('Audit créé lors de la validation de la demande.');

        $em->remove($demande);
        $em->persist($audit);
        $em->flush();

        $this->addFlash('success', sprintf('Demande validée pour "%s".', $producteur->getNom()));
        return $this->redirectToRoute('app_admin_dashboard', ['tab' => 'demandes']);
    }

    #[Route('/valider-audit/{id}', name: 'app_admin_valider_audit', methods: ['POST'])]
    public function validerAudit(Audit $audit, EntityManagerInterface $em, Request $request): Response
    {
        if (!$this->isCsrfTokenValid('valider_audit' . $audit->getId(), $request->request->get('_token'))) {
            $this->addFlash('success', 'Token CSRF invalide.');
            return $this->redirectToRoute('app_admin_dashboard', ['tab' => 'audits']);
        }

        $producteur = $audit->getProducteur();
        $producteur->setStatut('Actif');
        $audit->setResultat('Validé');
        $em->remove($audit);
        $em->flush();

        $this->addFlash('success', sprintf('Audit validé pour "%s".', $producteur->getNom()));
        return $this->redirectToRoute('app_admin_dashboard', ['tab' => 'prod']);
    }
}