<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('doctor_paient', function (Blueprint $table) {
            $table->foreignId('doctor_id')->constrained('users');
            $table->foreignId('paient_id')->constrained('users');
            $table->primary(['doctor_id' , 'paient_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('doctor_paient');
    }
};
