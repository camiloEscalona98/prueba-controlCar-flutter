# Pokémon App

## Descripción

Esta aplicación de Pokémon permite a los usuarios buscar y capturar Pokémon de forma fácil y divertida. Desarrollada con Flutter, la aplicación se basa en la arquitectura Modelo-Vista-Servicio (MVS), lo que permite una mejor organización y mantenimiento del código.

Mis habilidades están principalmente en el desarrollo de aplicaciones móviles, por lo que se utilizó la PokeAPI para obtener información sobre los Pokémon. Sin embargo, tengo planes de desarrollar una API en Node.js, aunque no se ha implementado en esta versión de la aplicación.

## Características

- **Búsqueda de Pokémon**: Busca Pokémon por nombre o tipo utilizando la PokeAPI.
- **Captura y almacenamiento**: Utiliza SharedPreferences para almacenar los Pokémon capturados, asegurando que siempre estén disponibles, incluso después de cerrar la aplicación.
- **Evaluación de equipos**: Implementación de un módulo simple que utiliza ChatGPT para evaluar el equipo seleccionado, mostrando cómo integrar inteligencia artificial en aplicaciones Flutter.

## Arquitectura

La aplicación se ha diseñado con una arquitectura Modelo-Vista-Servicio para diferenciar el código en secciones claras y manejables. Además, se ha priorizado la componetización de los widgets, permitiendo la reutilización de componentes en diferentes partes de la aplicación.

## Tecnologías Utilizadas

- **Flutter**: Framework utilizado para el desarrollo de la aplicación.
- **PokeAPI**: API para obtener información sobre Pokémon.
- **HTTP**: Para realizar las solicitudes a la API.
- **SharedPreferences**: Para almacenar los Pokémon capturados.
- **ChatGPT**: Integración para la evaluación de equipos.

## Limitaciones

- **Manejo de errores**: Debido a que es un proyecto pequeño, no se resolvieron todas las excepciones o errores posibles. Se manejaron los principales, pero podrían surgir otros durante su uso.
- **Arquitectura**: No se implementó la Clean Architecture debido al tamaño del proyecto. Se optó por una arquitectura Modelo-Vista-Servicio para simplificar el desarrollo.
- **Traducciones**: No se integraron traducciones, por lo que la aplicación actualmente solo está disponible en español.
- **Sistema de caché**: No se implementó un sistema de caché para mejorar el rendimiento, lo que podría ser considerado en futuras versiones.


## Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/camiloEscalona98/prueba-controlCar-flutter.git

## Recursos Visuales

Para ver imágenes y un video del funcionamiento de la aplicación, visita el siguiente enlace:

[Imágenes y Video de la Aplicación](https://drive.google.com/drive/folders/1mfkhh9GMPHC_Vtn6u4UxYcrF__tx0eoh?usp=sharing)

En este enlace podrás observar cómo funciona la aplicación, desde la búsqueda de Pokémon hasta la captura y almacenamiento de los mismos.

## Descarga del APK

Puedes descargar el APK de la aplicación desde el siguiente enlace:

[Descargar APK](https://drive.google.com/drive/folders/1HaRsiMjhDuZeYuyPsC2QaEAIHkDmGkgy?usp=sharing)

Nota: Al instalar la aplicación, es probable que Android solicite permisos adicionales para permitir la instalación de aplicaciones de fuentes externas. Asegúrate de habilitar la opción de instalar aplicaciones desde fuentes desconocidas en la configuración de tu dispositivo.
