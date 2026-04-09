<?php

namespace App\Entity;

use App\Repository\ProduitRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ProduitRepository::class)]
class Produit
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $nom = null;

    #[ORM\ManyToOne(inversedBy: 'produits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Producteur $producteur = null;

    #[ORM\ManyToOne(inversedBy: 'produits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?QuantiteType $quantite_type = null;

    /**
     * @var Collection<int, ProduitPanier>
     */
    #[ORM\OneToMany(targetEntity: ProduitPanier::class, mappedBy: 'produit')]
    private Collection $produitPaniers;

    /**
     * @var Collection<int, ProduitSurLeTemps>
     */
    #[ORM\OneToMany(targetEntity: ProduitSurLeTemps::class, mappedBy: 'produit')]
    private Collection $produitSurLeTemps;

    public function __construct()
    {
        $this->produitPaniers = new ArrayCollection();
        $this->produitSurLeTemps = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNom(): ?string
    {
        return $this->nom;
    }

    public function setNom(string $nom): static
    {
        $this->nom = $nom;

        return $this;
    }

    public function getProducteur(): ?Producteur
    {
        return $this->producteur;
    }

    public function setProducteur(?Producteur $producteur): static
    {
        $this->producteur = $producteur;

        return $this;
    }

    public function getQuantiteType(): ?QuantiteType
    {
        return $this->quantite_type;
    }

    public function setQuantiteType(?QuantiteType $quantite_type): static
    {
        $this->quantite_type = $quantite_type;

        return $this;
    }

    /**
     * @return Collection<int, ProduitPanier>
     */
    public function getProduitPaniers(): Collection
    {
        return $this->produitPaniers;
    }

    public function addProduitPanier(ProduitPanier $produitPanier): static
    {
        if (!$this->produitPaniers->contains($produitPanier)) {
            $this->produitPaniers->add($produitPanier);
            $produitPanier->setProduit($this);
        }

        return $this;
    }

    public function removeProduitPanier(ProduitPanier $produitPanier): static
    {
        if ($this->produitPaniers->removeElement($produitPanier)) {
            // set the owning side to null (unless already changed)
            if ($produitPanier->getProduit() === $this) {
                $produitPanier->setProduit(null);
            }
        }

        return $this;
    }

    /**
     * @return Collection<int, ProduitSurLeTemps>
     */
    public function getProduitSurLeTemps(): Collection
    {
        return $this->produitSurLeTemps;
    }

    public function addProduitSurLeTemp(ProduitSurLeTemps $produitSurLeTemp): static
    {
        if (!$this->produitSurLeTemps->contains($produitSurLeTemp)) {
            $this->produitSurLeTemps->add($produitSurLeTemp);
            $produitSurLeTemp->setProduit($this);
        }

        return $this;
    }

    public function removeProduitSurLeTemp(ProduitSurLeTemps $produitSurLeTemp): static
    {
        if ($this->produitSurLeTemps->removeElement($produitSurLeTemp)) {
            // set the owning side to null (unless already changed)
            if ($produitSurLeTemp->getProduit() === $this) {
                $produitSurLeTemp->setProduit(null);
            }
        }

        return $this;
    }
}
