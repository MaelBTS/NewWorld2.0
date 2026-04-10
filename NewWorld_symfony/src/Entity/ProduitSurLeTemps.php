<?php

namespace App\Entity;

use App\Repository\ProduitSurLeTempsRepository;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Get;

#[ApiResource(operations: [
    new Patch(),
    new Get()
])]
#[ORM\Entity(repositoryClass: ProduitSurLeTempsRepository::class)]
class ProduitSurLeTemps
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column]
    private ?float $prix_achat = null;

    #[ORM\Column]
    private ?float $prix_vente = null;

    #[ORM\Column]
    private ?float $tva = null;

    #[ORM\Column]
    private ?float $quantite = null;

    #[ORM\Column]
    private ?\DateTime $date_debut_prix_achat = null;

    #[ORM\Column]
    private ?\DateTime $date_fin_prix_achat = null;

    #[ORM\Column]
    private ?\DateTime $date_debut_prix_vente = null;

    #[ORM\Column]
    private ?\DateTime $date_fin_prix_vente = null;

    #[ORM\Column]
    private ?\DateTime $date_debut_tva = null;

    #[ORM\Column]
    private ?\DateTime $date_fin_tva = null;

    #[ORM\ManyToOne(inversedBy: 'produitSurLeTemps')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Produit $produit = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getPrixAchat(): ?float
    {
        return $this->prix_achat;
    }

    public function setPrixAchat(float $prix_achat): static
    {
        $this->prix_achat = $prix_achat;

        return $this;
    }

    public function getPrixVente(): ?float
    {
        return $this->prix_vente;
    }

    public function setPrixVente(float $prix_vente): static
    {
        $this->prix_vente = $prix_vente;

        return $this;
    }

    public function getTva(): ?float
    {
        return $this->tva;
    }

    public function setTva(float $tva): static
    {
        $this->tva = $tva;

        return $this;
    }

    public function getQuantite(): ?float
    {
        return $this->quantite;
    }

    public function setQuantite(float $quantite): static
    {
        $this->quantite = $quantite;

        return $this;
    }

    public function getDateDebutPrixAchat(): ?\DateTime
    {
        return $this->date_debut_prix_achat;
    }

    public function setDateDebutPrixAchat(\DateTime $date_debut_prix_achat): static
    {
        $this->date_debut_prix_achat = $date_debut_prix_achat;

        return $this;
    }

    public function getDateFinPrixAchat(): ?\DateTime
    {
        return $this->date_fin_prix_achat;
    }

    public function setDateFinPrixAchat(\DateTime $date_fin_prix_achat): static
    {
        $this->date_fin_prix_achat = $date_fin_prix_achat;

        return $this;
    }

    public function getDateDebutPrixVente(): ?\DateTime
    {
        return $this->date_debut_prix_vente;
    }

    public function setDateDebutPrixVente(\DateTime $date_debut_prix_vente): static
    {
        $this->date_debut_prix_vente = $date_debut_prix_vente;

        return $this;
    }

    public function getDateFinPrixVente(): ?\DateTime
    {
        return $this->date_fin_prix_vente;
    }

    public function setDateFinPrixVente(\DateTime $date_fin_prix_vente): static
    {
        $this->date_fin_prix_vente = $date_fin_prix_vente;

        return $this;
    }

    public function getDateDebutTva(): ?\DateTime
    {
        return $this->date_debut_tva;
    }

    public function setDateDebutTva(\DateTime $date_debut_tva): static
    {
        $this->date_debut_tva = $date_debut_tva;

        return $this;
    }

    public function getDateFinTva(): ?\DateTime
    {
        return $this->date_fin_tva;
    }

    public function setDateFinTva(\DateTime $date_fin_tva): static
    {
        $this->date_fin_tva = $date_fin_tva;

        return $this;
    }

    public function getProduit(): ?Produit
    {
        return $this->produit;
    }

    public function setProduit(?Produit $produit): static
    {
        $this->produit = $produit;

        return $this;
    }
}
