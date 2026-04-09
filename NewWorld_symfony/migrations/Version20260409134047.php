<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260409134047 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__produit_sur_le_temps AS SELECT id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva FROM produit_sur_le_temps');
        $this->addSql('DROP TABLE produit_sur_le_temps');
        $this->addSql('CREATE TABLE produit_sur_le_temps (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, prix_achat DOUBLE PRECISION NOT NULL, prix_vente DOUBLE PRECISION NOT NULL, tva DOUBLE PRECISION NOT NULL, quantite DOUBLE PRECISION NOT NULL, date_debut_prix_achat DATETIME NOT NULL, date_fin_prix_achat DATETIME NOT NULL, date_debut_prix_vente DATETIME NOT NULL, date_fin_prix_vente DATETIME NOT NULL, date_debut_tva DATETIME NOT NULL, date_fin_tva DATETIME NOT NULL, produit_id INTEGER NOT NULL, CONSTRAINT FK_170CC30CF347EFB FOREIGN KEY (produit_id) REFERENCES produit (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO produit_sur_le_temps (id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva) SELECT id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva FROM __temp__produit_sur_le_temps');
        $this->addSql('DROP TABLE __temp__produit_sur_le_temps');
        $this->addSql('CREATE INDEX IDX_170CC30CF347EFB ON produit_sur_le_temps (produit_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__produit_sur_le_temps AS SELECT id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva FROM produit_sur_le_temps');
        $this->addSql('DROP TABLE produit_sur_le_temps');
        $this->addSql('CREATE TABLE produit_sur_le_temps (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, prix_achat DOUBLE PRECISION NOT NULL, prix_vente DOUBLE PRECISION NOT NULL, tva DOUBLE PRECISION NOT NULL, quantite DOUBLE PRECISION NOT NULL, date_debut_prix_achat DATETIME NOT NULL, date_fin_prix_achat DATETIME NOT NULL, date_debut_prix_vente DATETIME NOT NULL, date_fin_prix_vente DATETIME NOT NULL, date_debut_tva DATETIME NOT NULL, date_fin_tva DATETIME NOT NULL)');
        $this->addSql('INSERT INTO produit_sur_le_temps (id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva) SELECT id, prix_achat, prix_vente, tva, quantite, date_debut_prix_achat, date_fin_prix_achat, date_debut_prix_vente, date_fin_prix_vente, date_debut_tva, date_fin_tva FROM __temp__produit_sur_le_temps');
        $this->addSql('DROP TABLE __temp__produit_sur_le_temps');
    }
}
