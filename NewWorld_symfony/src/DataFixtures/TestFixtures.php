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
        $quantite_type = new QuantiteType();
        $quantite_type->setType("Kilogramme");
        $manager->persist($quantite_type);
        $quantite_type = new QuantiteType();
        $quantite_type->setType("gramme");
        $manager->persist($quantite_type);
        $quantite_type = new QuantiteType();
        $quantite_type->setType("litre");
        $manager->persist($quantite_type);
        $quantite_type = new QuantiteType();
        $quantite_type->setType("unité");
        $manager->persist($quantite_type);

        $producteur = new Producteur();
        $producteur->setNom("Producteur Test");
        $producteur->setAdresse("123 Rue du Test");
        $producteur->setVille("Testville");
        $producteur->setCodePostal("12345");
        $producteur->setEmail('test@example.com');
        $producteur->setTelephone('0123456789');
        $producteur->setNumeroSiret('12345678901234');
        $manager->persist($producteur);

        

        $produit = new Produit();
        $produit->setNom("Produit Test");
        $produit->setProducteur($producteur);
        $produit->setQuantiteType($quantite_type);
        $manager->persist($produit);
        
        $produit_sur_le_temps = new ProduitSurLeTemps();
        $produit_sur_le_temps->setDateDebutPrixAchat(new \DateTime('2026-01-01'));
        $produit_sur_le_temps->setDateFinPrixAchat(new \DateTime('2026-12-31'));
        $produit_sur_le_temps->setDateDebutPrixVente(new \DateTime('2026-01-01'));
        $produit_sur_le_temps->setDateFinPrixVente(new \DateTime('2026-12-31'));
        $produit_sur_le_temps->setDateDebutTva(new \DateTime('2026-01-01'));
        $produit_sur_le_temps->setDateFinTva(new \DateTime('2026-12-31'));
        $produit_sur_le_temps->setPrixAchat(10.00);
        $produit_sur_le_temps->setPrixVente(15.00);
        $produit_sur_le_temps->setTva(20.00);
        $produit_sur_le_temps->setQuantite(100);
        $produit_sur_le_temps->setProduit($produit);
        $manager->persist($produit_sur_le_temps);

        $manager->flush();
    }
}
