<script setup lang="ts">
import { computed } from 'vue';
import { useLoanApplicationStore } from '~/stores/loanApplication';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';

const store = useLoanApplicationStore();

const isStepValid = computed(() => {
  return store.full_name !== '' &&
         store.isSaIdValid &&
         store.isAgeValid &&
         store.monthly_income !== null && store.monthly_income > 0 &&
         store.proof_document_name !== null && store.proof_document_name !== '' &&
         store.selected_phone_id !== null &&
         store.loanPrincipal !== null &&
         store.totalLoanAmount !== null &&
         store.dailyPayment !== null;
});

// Expose validation status for parent component
defineExpose({
  isStepValid,
});
</script>

<template>
  <Card class="w-full max-w-md mx-auto">
    <CardHeader>
      <CardTitle>Review and Submit</CardTitle>
      <CardDescription>Please review your application details before submitting.</CardDescription>
    </CardHeader>
    <CardContent>
      <div class="grid gap-4">
        <h3 class="text-lg font-semibold">Personal Information</h3>
        <div class="grid gap-1">
          <p><strong>Full Name:</strong> {{ store.full_name }}</p>
          <p><strong>SA ID Number:</strong> {{ store.sa_id_number }}</p>
          <p><strong>Birthday:</strong> {{ store.birthday }} (Age: {{ store.applicantAge }})</p>
        </div>
        <Separator />

        <h3 class="text-lg font-semibold">Income Details</h3>
        <div class="grid gap-1">
          <p><strong>Monthly Income:</strong> R{{ store.monthly_income?.toFixed(2) }}</p>
          <p><strong>Proof Document:</strong> {{ store.proof_document_name || 'Not uploaded' }}</p>
        </div>
        <Separator />

        <h3 class="text-lg font-semibold">Phone & Loan Details</h3>
        <div v-if="store.selectedPhone" class="grid gap-1">
          <p><strong>Selected Phone:</strong> {{ store.selectedPhone.model_name }} (Cash Price: R{{ store.selectedPhone.cash_price.toFixed(2) }})</p>
          <p><strong>Risk Profile:</strong> Age {{ store.applicantAge }} (Deposit: {{ (store.riskProfile?.deposit * 100).toFixed(0) }}%, Interest: {{ (store.riskProfile?.interest * 100).toFixed(0) }}%)</p>
          <p><strong>Loan Principal:</strong> R{{ store.loanPrincipal?.toFixed(2) }}</p>
          <p><strong>Total Loan Amount:</strong> R{{ store.totalLoanAmount?.toFixed(2) }}</p>
          <p class="text-lg font-bold"><strong>Daily Payment:</strong> R{{ store.dailyPayment?.toFixed(2) }}</p>
        </div>
        <div v-else>
          <p class="text-red-500">No phone selected or loan details calculated.</p>
        </div>
        <Separator />

        <p v-if="store.existingApplicationId" class="text-orange-500 text-sm italic">
          You have an existing application. Submitting this form will override your previous application.
        </p>
        <p v-if="store.status === 'SUBMITTED'" class="text-green-500 text-center mt-2">Your application has been successfully submitted!</p>
        <p v-if="store.status === 'ERROR'" class="text-red-500 text-center mt-2">There was an error submitting your application. Please try again.</p>
      </div>
    </CardContent>
  </Card>
</template>
