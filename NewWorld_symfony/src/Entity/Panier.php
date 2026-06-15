<?php

namespace App\Entity;

use App\Repository\PanierRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\GetCollection;

#[ApiFilter(SearchFilter::class, properties: ['user' => 'exact'])]

#[ApiResource(operations: [
    new Get(),
    new GetCollection(),
    new Post(),
    new Patch(),
])]
#[ORM\Entity(repositoryClass: PanierRepository::class)]
class Panier
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\OneToOne(inversedBy: 'panier', cascade: ['persist', 'remove'])]
    #[ORM\JoinColumn(nullable: false)]
    private ?Users $user = null;

    #[ORM\Column(length: 255)]
    private ?string $statut = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTime $date_facturation = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTime $date_livraison = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $commentaire = null;

    /**
     * @var Collection<int, ProduitPanier>
     */
    #[ORM\OneToMany(targetEntity: ProduitPanier::class, mappedBy: 'panier', cascade: ['persist', 'remove'])]
    private Collection $produitPaniers;

    public function __construct()
    {
        $this->produitPaniers = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getUser(): ?Users
    {
        return $this->user;
    }

    public function setUser(Users $user): static
    {
        $this->user = $user;

        return $this;
    }

    public function getStatut(): ?string
    {
        return $this->statut;
    }

    public function setStatut(string $statut): static
    {
        $this->statut = $statut;

        return $this;
    }

    public function getDateFacturation(): ?\DateTime
    {
        return $this->date_facturation;
    }

    public function setDateFacturation(?\DateTime $date_facturation): static
    {
        $this->date_facturation = $date_facturation;

        return $this;
    }

    public function getDateLivraison(): ?\DateTime
    {
        return $this->date_livraison;
    }

    public function setDateLivraison(?\DateTime $date_livraison): static
    {
        $this->date_livraison = $date_livraison;

        return $this;
    }

    public function getCommentaire(): ?string
    {
        return $this->commentaire;
    }

    public function setCommentaire(?string $commentaire): static
    {
        $this->commentaire = $commentaire;

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
            $produitPanier->setPanier($this);
        }

        return $this;
    }

    public function removeProduitPanier(ProduitPanier $produitPanier): static
    {
        if ($this->produitPaniers->removeElement($produitPanier)) {
            // set the owning side to null (unless already changed)
            if ($produitPanier->getPanier() === $this) {
                $produitPanier->setPanier(null);
            }
        }

        return $this;
    }
}
