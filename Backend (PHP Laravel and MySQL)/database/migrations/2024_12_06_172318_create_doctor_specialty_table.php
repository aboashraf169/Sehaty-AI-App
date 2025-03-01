<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('doctor_specialty', function (Blueprint $table) {
            $table->id();
            $table->foreignId('doctor_id')->constrained('users')->onDelete('cascade'); // Foreign key for doctors
            $table->foreignId('specialty_id')->constrained('specialties')->onDelete('cascade'); // Foreign key for specialties
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('doctor_specialty');
    }
};
