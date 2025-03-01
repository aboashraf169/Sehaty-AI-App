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
        Schema::create('user_liked_article', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->references('id');
            $table->foreignId('article_id')->constrained('articles')->references('id');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_liked_article');
    }
};
