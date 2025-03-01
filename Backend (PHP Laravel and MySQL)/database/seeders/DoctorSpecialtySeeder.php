<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DoctorSpecialtySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
       $doctors = User::where('is_doctor' , true)->get();
       $i = 1;
        foreach($doctors as $doctor){
            $doctor->specialty()->attach($i++);
        }
    }
}
