<?php

namespace App\Entity;

use App\Entity\Producteur;
use App\Repository\AuditRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: AuditRepository::class)]
class Audit
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column]
    private ?\DateTimeImmutable $dateAudit = null;

    #[ORM\Column(length: 20)]
    private ?string $resultat = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $commentaire = null;

    // Relation ManyToOne vers Producteur, avec inversedBy
    #[ORM\ManyToOne(targetEntity: Producteur::class, inversedBy: 'audits')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Producteur $producteur = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getDateAudit(): ?\DateTimeImmutable
    {
        return $this->dateAudit;
    }

    public function setDateAudit(\DateTimeImmutable $dateAudit): static
    {
        $this->dateAudit = $dateAudit;

        return $this;
    }

    public function getResultat(): ?string
    {
        return $this->resultat;
    }

    public function setResultat(string $resultat): static
    {
        $this->resultat = $resultat;

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

    public function getProducteur(): ?Producteur
    {
        return $this->producteur;
    }

    public function setProducteur(?Producteur $producteur): static
    {
        $this->producteur = $producteur;

        return $this;
    }
}
