<?php

namespace App\Controller;

use App\Entity\Demandes;
use App\Form\DemandeInscriptionType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class CandidatureController extends AbstractController
{
    #[Route('/candidature', name: 'app_candidature')]
    public function new(Request $request, EntityManagerInterface $em): Response
    {
        $demande = new Demandes();

        $form = $this->createForm(DemandeInscriptionType::class, $demande, [
            'attr' => ['class' => 'primary-form']
        ]);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {

            $demande->setStatut('soumis');
            $demande->setDateDemande(new \DateTimeImmutable());

            $em->persist($demande);
            $em->flush();

            return $this->redirectToRoute('app_candidature');
        }

        return $this->render('candidature/new.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}