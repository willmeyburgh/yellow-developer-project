<script setup lang="ts">
import { useLoanApplicationStore } from '~/stores/loanApplication';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

const store = useLoanApplicationStore();

const resetFormAndStartOver = () => {
  store.resetForm();
};
</script>

<template>
  <Card class="w-full max-w-md mx-auto text-center">
    <CardHeader>
      <CardTitle>Thank You!</CardTitle>
      <CardDescription>Your loan application has been successfully submitted.</CardDescription>
    </CardHeader>
    <CardContent>
      <p class="mb-4">We appreciate you taking the time to fill out the form. We will review your application shortly.</p>
      <p class="mb-6">You can review your application details in the previous step if needed.</p>
      <Button @click="resetFormAndStartOver">
        Start a New Application
      </Button>
    </CardContent>
  </Card>
</template>
