<?php

namespace Database\Seeders;

use App\Models\Specialty;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Database\Seeders\DoctorSeeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {


        Seeder::call([DoctorSeeder::class , UserSeeder::class , SpecialtySeeder::class , FollowingDoctorsSeeder::class ,      DoctorSpecialtySeeder::class , DoctorsArtilcesSeeder::class]);
        // $this->call(DoctorsArtilcesSeeder::class);


    }
}
