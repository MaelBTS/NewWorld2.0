<?php

namespace App\DataFixtures;

use App\Entity\Users;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $secre = new Users();
        $secre->setEmail("secre@gmail.com");
        $secre->setPassword(password_hash('secre01', PASSWORD_DEFAULT));
        $secre->setRoles(["ROLE_SECRETAIRE"]);

        $admin = new Users();
        $admin->setEmail("admin@gmail.com");
        $admin->setPassword(password_hash('admin01', PASSWORD_DEFAULT));
        $admin->setRoles(["ROLE_ADMIN"]);

        $manager->persist($secre);
        $manager->persist($admin);

        $manager->flush();
    }
}
