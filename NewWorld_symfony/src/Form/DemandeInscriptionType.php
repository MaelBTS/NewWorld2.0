<?php

namespace App\Form;

use App\Entity\Demandes;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class DemandeInscriptionType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('nom', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('adresse', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('ville', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('codePostal', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('email', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('telephone', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('numeroSiret', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
            ->add('commentaire', options: [
                'label_attr' => [
                    'class' => 'primary-form__label'
                ],
                'attr'=> [
                    'class' => 'primary-form__input'
                ],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Demandes::class,
        ]);
    }
}
