<?php

namespace App\Entity;

use App\Repository\ArchiveProducteurRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ArchiveProducteurRepository::class)]
class ArchiveProducteur
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column]
    private ?int $ancienId = null;

    #[ORM\Column]
    private array $data = [];

    #[ORM\Column]
    private ?\DateTimeImmutable $dateArchivage = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getAncienId(): ?int
    {
        return $this->ancienId;
    }

    public function setAncienId(int $ancienId): static
    {
        $this->ancienId = $ancienId;

        return $this;
    }

    public function getData(): array
    {
        return $this->data;
    }

    public function setData(array $data): static
    {
        $this->data = $data;

        return $this;
    }

    public function getDateArchivage(): ?\DateTimeImmutable
    {
        return $this->dateArchivage;
    }

    public function setDateArchivage(\DateTimeImmutable $dateArchivage): static
    {
        $this->dateArchivage = $dateArchivage;

        return $this;
    }
}
