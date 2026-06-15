<?php

namespace App\Entity;

use App\Repository\ArchivesRepository;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\GetCollection;

#[ApiResource(operations: [
    new Post(),
    new GetCollection(),
])]
#[ORM\Entity(repositoryClass: ArchivesRepository::class)]
class Archives
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $type = null;

    #[ORM\Column]
    private ?int $ancien_id = null;

    #[ORM\Column(type: 'text')]
    private ?string $data = null;

    #[ORM\Column(length: 255)]
    private ?string $date_archivage = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getType(): ?string
    {
        return $this->type;
    }

    public function setType(string $type): static
    {
        $this->type = $type;
        return $this;
    }

    public function getAncienId(): ?int
    {
        return $this->ancien_id;
    }

    public function setAncienId(int $ancien_id): static
    {
        $this->ancien_id = $ancien_id;
        return $this;
    }

    public function getData(): ?string
    {
        return $this->data;
    }

    public function setData(string $data): static
    {
        $this->data = $data;
        return $this;
    }

    public function getDateArchivage(): ?string
    {
        return $this->date_archivage;
    }

    public function setDateArchivage(string $date_archivage): static
    {
        $this->date_archivage = $date_archivage;
        return $this;
    }
}
