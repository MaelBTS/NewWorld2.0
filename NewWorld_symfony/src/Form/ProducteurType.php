<?php

namespace App\Form;

use App\Entity\Producteur;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class ProducteurType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('nom', TextType::class, ['label' => 'NOM DE L\'EXPLOITATION'])
            ->add('email', EmailType::class, ['label' => 'EMAIL (IDENTIFIANT)'])
            ->add('plainPassword', PasswordType::class, [
                'label' => 'MOT DE PASSE',
                'required' => true, // Obligatoire à la création
            ])
            ->add('adresse', TextType::class, ['label' => 'ADRESSE'])
            ->add('codePostal', TextType::class, ['label' => 'CODE POSTAL'])
            ->add('ville', TextType::class, ['label' => 'VILLE'])
            ->add('telephone', TextType::class, ['label' => 'TÉLÉPHONE'])
            ->add('numeroSiret', TextType::class, ['label' => 'N° SIRET'])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Producteur::class,
        ]);
    }
}