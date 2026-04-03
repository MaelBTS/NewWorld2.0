<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260319144411 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE producteur ADD COLUMN delete_at DATETIME DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__producteur AS SELECT id, nom, adresse, ville, code_postal, email, telephone, numero_siret, statut, date_creation FROM producteur');
        $this->addSql('DROP TABLE producteur');
        $this->addSql('CREATE TABLE producteur (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, adresse VARCHAR(255) NOT NULL, ville VARCHAR(150) NOT NULL, code_postal VARCHAR(10) NOT NULL, email VARCHAR(255) NOT NULL, telephone VARCHAR(20) NOT NULL, numero_siret VARCHAR(14) NOT NULL, statut VARCHAR(50) NOT NULL, date_creation DATETIME NOT NULL)');
        $this->addSql('INSERT INTO producteur (id, nom, adresse, ville, code_postal, email, telephone, numero_siret, statut, date_creation) SELECT id, nom, adresse, ville, code_postal, email, telephone, numero_siret, statut, date_creation FROM __temp__producteur');
        $this->addSql('DROP TABLE __temp__producteur');
    }
}
