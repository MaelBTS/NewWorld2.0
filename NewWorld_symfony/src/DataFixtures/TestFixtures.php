<?php

namespace App\DataFixtures;

use App\Entity\Produit;
use App\Entity\Producteur;
use App\Entity\ProduitSurLeTemps;
use App\Entity\QuantiteType;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class TestFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $kg = new QuantiteType();
        $kg->setType("Kilogramme");
        $manager->persist($kg);

        $g = new QuantiteType();
        $g->setType("gramme");
        $manager->persist($g);

        $l = new QuantiteType();
        $l->setType("litre");
        $manager->persist($l);

        $unite = new QuantiteType();
        $unite->setType("unité");
        $manager->persist($unite);

        $producteur1 = new Producteur();
        $producteur1->setNom("Ferme Bio duVal");
        $producteur1->setAdresse("15 Rue des Champs");
        $producteur1->setVille("Saint-Rémy");
        $producteur1->setCodePostal("13210");
        $producteur1->setEmail("contact@fermebioduval.fr");
        $producteur1->setTelephone("0490123456");
        $producteur1->setNumeroSiret('81495235700019');
        $manager->persist($producteur1);

        $producteur2 = new Producteur();
        $producteur2->setNom("SARL Fruits du Soleil");
        $producteur2->setAdresse("8 Chemin des Vergers");
        $producteur2->setVille("Cavaillon");
        $producteur2->setCodePostal("84300");
        $producteur2->setEmail("commandes@fruitsdusoleil.fr");
        $producteur2->setTelephone("0490789101");
        $producteur2->setNumeroSiret('52185964300025');
        $manager->persist($producteur2);

        $producteur3 = new Producteur();
        $producteur3->setNom("Jardin des Saveurs");
        $producteur3->setAdresse("3 Impasse des Potagers");
        $producteur3->setVille("L'Isle-sur-la-Sorgue");
        $producteur3->setCodePostal("84800");
        $producteur3->setEmail("contact@jardindessaveurs.fr");
        $producteur3->setTelephone("0490345678");
        $producteur3->setNumeroSiret('39876543200011');
        $manager->persist($producteur3);

        $produits = [
            ['nom' => 'Pommes Golden', 'producteur' => $producteur1, 'type' => $kg, 'prix' => 3.50, 'tva' => 5.5, 'quantite' => 200],
            ['nom' => 'Carottes bio', 'producteur' => $producteur1, 'type' => $kg, 'prix' => 2.80, 'tva' => 5.5, 'quantite' => 150],
            ['nom' => 'Oranges sanguines', 'producteur' => $producteur2, 'type' => $kg, 'prix' => 4.20, 'tva' => 5.5, 'quantite' => 120],
            ['nom' => 'Jus de pomme', 'producteur' => $producteur2, 'type' => $l, 'prix' => 5.00, 'tva' => 20.0, 'quantite' => 80],
            ['nom' => 'Salade verte', 'producteur' => $producteur3, 'type' => $unite, 'prix' => 1.50, 'tva' => 5.5, 'quantite' => 300],
            ['nom' => 'Confiture de fraise', 'producteur' => $producteur3, 'type' => $g, 'prix' => 6.50, 'tva' => 20.0, 'quantite' => 60],
        ];

        foreach ($produits as $data) {
            $produit = new Produit();
            $produit->setNom($data['nom']);
            $produit->setProducteur($data['producteur']);
            $produit->setQuantiteType($data['type']);
            $manager->persist($produit);

            $produitSurLeTemps = new ProduitSurLeTemps();
            $produitSurLeTemps->setDateDebutPrixAchat(new \DateTime('2026-01-01'));
            $produitSurLeTemps->setDateFinPrixAchat(new \DateTime('2026-12-31'));
            $produitSurLeTemps->setDateDebutPrixVente(new \DateTime('2026-01-01'));
            $produitSurLeTemps->setDateFinPrixVente(new \DateTime('2026-12-31'));
            $produitSurLeTemps->setDateDebutTva(new \DateTime('2026-01-01'));
            $produitSurLeTemps->setDateFinTva(new \DateTime('2026-12-31'));
            $produitSurLeTemps->setPrixAchat($data['prix'] * 0.6);
            $produitSurLeTemps->setPrixVente($data['prix']);
            $produitSurLeTemps->setTva($data['tva']);
            $produitSurLeTemps->setQuantite($data['quantite']);
            $produitSurLeTemps->setProduit($produit);
            $manager->persist($produitSurLeTemps);
        }

        $manager->flush();
    }
}
