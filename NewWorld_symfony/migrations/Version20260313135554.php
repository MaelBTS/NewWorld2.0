<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260313135554 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE archive_producteur (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ancien_id INTEGER NOT NULL, data CLOB NOT NULL, date_archivage DATETIME NOT NULL)');
        $this->addSql('CREATE TABLE audit (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date_audit DATETIME NOT NULL, resultat VARCHAR(20) NOT NULL, commentaire CLOB DEFAULT NULL, producteur_id INTEGER NOT NULL, CONSTRAINT FK_9218FF79AB9BB300 FOREIGN KEY (producteur_id) REFERENCES producteur (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_9218FF79AB9BB300 ON audit (producteur_id)');
        $this->addSql('CREATE TABLE demandes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, adresse VARCHAR(255) NOT NULL, ville VARCHAR(150) NOT NULL, code_postal VARCHAR(10) NOT NULL, email VARCHAR(255) NOT NULL, telephone VARCHAR(20) NOT NULL, numero_siret VARCHAR(14) NOT NULL, statut VARCHAR(50) NOT NULL, date_demande DATETIME NOT NULL, commentaire CLOB DEFAULT NULL)');
        $this->addSql('CREATE TABLE producteur (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, adresse VARCHAR(255) NOT NULL, ville VARCHAR(150) NOT NULL, code_postal VARCHAR(10) NOT NULL, email VARCHAR(255) NOT NULL, telephone VARCHAR(20) NOT NULL, numero_siret VARCHAR(14) NOT NULL, statut VARCHAR(50) NOT NULL, date_creation DATETIME NOT NULL)');
        $this->addSql('CREATE TABLE secretaire (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL)');
        $this->addSql('CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, email VARCHAR(180) NOT NULL, roles CLOB NOT NULL, password VARCHAR(255) NOT NULL)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_EMAIL ON users (email)');
        $this->addSql('CREATE TABLE messenger_messages (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, body CLOB NOT NULL, headers CLOB NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at DATETIME NOT NULL, available_at DATETIME NOT NULL, delivered_at DATETIME DEFAULT NULL)');
        $this->addSql('CREATE INDEX IDX_75EA56E0FB7336F0E3BD61CE16BA31DBBF396750 ON messenger_messages (queue_name, available_at, delivered_at, id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE archive_producteur');
        $this->addSql('DROP TABLE audit');
        $this->addSql('DROP TABLE demandes');
        $this->addSql('DROP TABLE producteur');
        $this->addSql('DROP TABLE secretaire');
        $this->addSql('DROP TABLE users');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
