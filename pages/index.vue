<template>
  <div class="flex flex-col flex-grow">
    <Nav />
    <main class="container mx-auto px-4 py-8 flex-grow">
      <SignUpForm />
    </main>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import Nav from '@/components/Nav.vue'
import Footer from '@/components/Footer.vue'
import SignUpForm from '@/components/signup/SignUpForm.vue'
</script>