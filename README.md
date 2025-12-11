<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

Lineone Laravel Documentation
Requirements

Laravel framework needs a few requirements for getting installed on your system.

    PHP Latest Version
    Node.js Latest Version
    Composer

Installing Nodejs

If Node js is not installed on your machine, you must install it first. Node.js distributions usually come bundled with npm, a package manager for the platform, which runs from the command line and manages dependencies for your applications. All npm packages contain a file, usually in the project root, called package.json - this file holds metadata relevant to the project. As you’ve installed Node.js, you can verify to check whether the installation is successful or not. To check if you have Node.js installed, run this command in your terminal:
shell

node -v

And to check the npm version, type:
shell

npm -v

Installing PHP

To install PHP, we will suggest you to install All-in-One package software stack (*AMP). It is available for all operating systems:

    WAMP for Windows
    LAMP for Linux
    MAMP for Mac
    XAMPP

To learn how to install these packages, refer to the following address: https://www.javatpoint.com/install-php

For check if you have PHP installed, run this command in your terminal:
shell

php -v

Installing Composer

Laravel implements a composer for managing dependencies within it. Hence, before using Laravel, it needs to check whether you have a composer set up on your system or not. If you don't have Composer installed on your computer, first visit this URL to download Composer:

https://getcomposer.org/download/

When you are done installing the Composer, cross-check whether it is installed or not by typing in the command prompt the composer command. You can see the Composer screen in that CMD only.
Installing Template
Setup

Download the package. Go to lineone-laravel directory, open terminal and run following commands:
shell

composer install

shell

npm install

Duplicate .env.example file and rename it to .env adjust database connection depends on your local database setup.

Update the .env with the database name you want to connect to, as well as the other environment variables if they differ from the default.
env

# For MySql DB
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=yourdb
DB_USERNAME=root
DB_PASSWORD=

# OR
# For SQLite DB 
DB_CONNECTION=sqlite

Then generate the project key:
shell

php artisan key:generate

WARNING

For applications using a server based databases (like MySQL), ensure the server is running before proceeding.

Run following command to setup the database structure and seeds.
shell

php artisan migrate --seed

Starting Laravel Development server

Make sure your in Laravel's project root directory. Than run the following command
shell

php artisan serve

This starts your app’s on port 8000. Let’s check to see if it’s working. http://localhost:8000from your browser.
Running Vite

There are two ways you can run Vite. You may run the development server via the dev command, which is useful while developing locally. The development server will automatically detect changes to your files and instantly reflect them in any open browser windows.
shell

npm run dev

Or, running the build command will version and bundle your application's assets and get them ready for you to deploy to production:
shell

npm run build

Customization

image_2023-07-10_08-38-04image_2023-07-10_08-39-20image_2023-07-10_08-40-31

Tailwind CSS is a highly customizable framework. For learning more about customizing the Tailwind template, please use the official documentation of Tailwind.
Customizing Colors

To customize colors you should change customColors values in tailwind.config.js file:
js

const customColors = {
  // ..
  primary: colors.indigo["600"],
  secondary: "#F000B9",
  // ..
};

Dark Mode

To enable Dark Mode by default change isDarkModeEnabled value in store.js file from:
js

export default {
  // ...
  init() {
    // ...
    this.isDarkModeEnabled = Alpine.$persist(false).as("_x_darkMode_on");
    // ...
  },
  // ...
};

to
js

export default {
  // ...
  init() {
    // ...
    this.isDarkModeEnabled = Alpine.$persist(true).as("_x_darkMode_on");
    // ...
  },
  // ...
};

Monochrome Mode

To enable Monochrome Mode change isMonochromeModeEnabled value in store.js file from:
js

export default {
  //   ...
  isMonochromeModeEnabled: false,
  //   ...
};

to
js

export default {
  //   ...
  isMonochromeModeEnabled: true,
  //   ...
};

Also, you can persist this value by adding this code on init function in store.js file:
js

export default {
  // ...
  init() {
    // ...
    this.isMonochromeModeEnabled: Alpine.$persist(true).as("_x_monochrome_Mode_on");
    // ...
  }
  // ...
}

Customization Layout

To expand sidebar by default add this attribute is-sidebar-open="true" in <x-base-layout> or <x-app-layout> tag:
HTML

<!-- /// -->
<x-base-layout title="Page Title" is-sidebar-open="true" is-header-blur="true">
<!-- /// -->

Header Status

Header can be static or sticky. By default, the header is sticky. If you want to make the header static add header-sticky="false" in layout:
HTML

<!-- /// -->
 <x-app-layout header-sticky="false">
<!-- /// -->

Livewire 3 Guide

Livewire is not installed by default in our theme. if you are using livewire you should apply following changes:

    In app.js, replace the Alpine import with the following:

js

import Alpine from "alpinejs"; 

import { 
  Livewire, 
  Alpine, 
} from "../../vendor/livewire/livewire/dist/livewire.esm"; 

    Remove the following lines from app.js:

js

// AlpineJS Plugins
import persist from "@alpinejs/persist"; // @see https://alpinejs.dev/plugins/persist
import collapse from "@alpinejs/collapse"; // @see https://alpinejs.dev/plugins/collapse
import intersect from "@alpinejs/intersect"; // @see https://alpinejs.dev/plugins/intersect

// -----------------------------------------------

Alpine.plugin(persist); 
Alpine.plugin(collapse); 
Alpine.plugin(intersect); 

    Add the following line to app.js:

js

// -----------------------------------------------

window.Alpine = Alpine;
window.Livewire = Livewire; 
window.helpers = helpers;
window.pages = pages;

// -----------------------------------------------

    Wrap your custom Alpine components in the Alpine init listener in app.js:

js

// -----------------------------------------------

Alpine.directive("tooltip", tooltip); 
Alpine.directive("input-mask", inputMask); 

Alpine.magic("notification", () => notification); 
Alpine.magic("clipboard", () => clipboard); 

Alpine.store("breakpoints", breakpoints); 
Alpine.store("global", store); 

Alpine.data("usePopper", usePopper); 
Alpine.data("accordionItem", accordionItem); 

// -----------------------------------------------

document.addEventListener("alpine:init", () => { 
  Alpine.directive("tooltip", tooltip); 
  Alpine.directive("input-mask", inputMask); 

  Alpine.magic("notification", () => notification); 
  Alpine.magic("clipboard", () => clipboard); 

  Alpine.store("breakpoints", breakpoints); 
  Alpine.store("global", store); 

  Alpine.data("usePopper", usePopper); 
  Alpine.data("accordionItem", accordionItem); 
}); 

Next, In layout file (views/components/app-layout.blade.php) apply following changes:

Add Livewire directives:
html

<!-- //////////////////// -->

<meta name="csrf-token" content="{{ csrf_token() }}" />
<meta
  name="viewport"
  content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
/>
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<title>{{ config('app.name') }} @isset($title) - {{ $title }} @endisset</title>

@livewireStyles

<!-- CSS & JS Assets -->
@vite(['resources/css/app.css', 'resources/js/app.js'])

<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
  href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
  rel="stylesheet"
/>

<!-- //////////////////// -->
<div id="x-teleport-target"></div>

@livewireScriptConfig

<script>
  window.addEventListener("DOMContentLoaded", () => Alpine.start()); 
  window.addEventListener("DOMContentLoaded", () => Livewire.start()); 
</script>

Now You can make your livewire components:
shell

php artisan make:livewire counter

Open app/Livewire/Counter.php and replace its contents with the following:
php


<?php

namespace App\Livewire;

use Livewire\Component;

class Counter extends Component
{
    public $count = 1;

    public function increment()
    {
        $this->count++;
    }

    public function decrement()
    {
        $this->count--;
    }

    public function render()
    {
        return view('livewire.counter')->layout('components.app-layout', ['title' => 'Counter']);
    }
}

Open the resources/views/livewire/counter.blade.php file and replace its content with the following:
html

<main class="main-content w-full px-[var(--margin-x)] pb-8">
  <div class="flex items-center space-x-4 py-5 lg:py-6">
    <h2
      class="text-xl font-medium text-slate-800 dark:text-navy-50 lg:text-2xl"
    >
      Counter
    </h2>
  </div>
  <h1>{{ $count }}</h1>

  <button wire:click="increment">+</button>

  <button wire:click="decrement">-</button>
</main>



## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

- **[Vehikl](https://vehikl.com)**
- **[Tighten Co.](https://tighten.co)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Curotec](https://www.curotec.com/services/technologies/laravel)**
- **[DevSquad](https://devsquad.com/hire-laravel-developers)**
- **[Redberry](https://redberry.international/laravel-development)**
- **[Active Logic](https://activelogic.com)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
#   p - c i j e s  
 