<?php
// src/State/UserPasswordHasher.php
namespace App\State;

use ApiPlatform\Metadata\Operation;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\Users;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserPasswordHasher implements ProcessorInterface
{
    public function __construct(
        private ProcessorInterface $processor,
        private UserPasswordHasherInterface $passwordHasher,
    ) {}

    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): mixed
    {
        if (!$data instanceof Users || !$data->getPassword()) {
            return $this->processor->process($data, $operation, $uriVariables, $context);
        }

        // Éviter de re-hasher un mot de passe déjà hashé (lors d'un PATCH)
        $password = $data->getPassword();
        if (str_starts_with($password, '$2y$') || str_starts_with($password, '$argon')) {
            return $this->processor->process($data, $operation, $uriVariables, $context);
        }

        // ✅ Hash le mot de passe avant de persister
        $hashedPassword = $this->passwordHasher->hashPassword($data, $password);
        $data->setPassword($hashedPassword);

        return $this->processor->process($data, $operation, $uriVariables, $context);
    }
}