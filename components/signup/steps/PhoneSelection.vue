<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useLoanApplicationStore } from '~/stores/loanApplication';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { Separator } from '@/components/ui/separator';

const store = useLoanApplicationStore();

const selectedPhoneId = ref<number | null>(store.selected_phone_id);

watch(selectedPhoneId, (newValue) => {
  store.setSelectedPhone(newValue as number);
});

// Update local ref if store values change (e.g., on form reset)
watch(() => store.selected_phone_id, (newValue) => {
  selectedPhoneId.value = newValue;
});

const isStepValid = computed(() => {
  return store.selected_phone_id !== null &&
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
      <CardTitle>Phone Selection & Dynamic Pricing</CardTitle>
      <CardDescription>Choose an affordable phone model.</CardDescription>
    </CardHeader>
    <CardContent>
      <div v-if="!store.monthly_income || store.monthly_income <= 0" class="text-red-500 mb-4">
        Please provide your monthly income in the previous step to see affordable phones.
      </div>
      <div v-else-if="!store.isAgeValid" class="text-red-500 mb-4">
        Your age must be between 18 and 65 to proceed with phone selection.
      </div>
      <div v-else>
        <h3 class="text-lg font-semibold mb-4">Available Phones (Affordable)</h3>
        <RadioGroup v-model="selectedPhoneId" class="grid gap-4">
          <div v-if="store.affordablePhones.length === 0" class="text-gray-500">
            No phones available based on your affordability.
          </div>
          <div v-for="phone in store.affordablePhones" :key="phone.id" class="flex items-center space-x-2 border p-4 rounded-md">
            <RadioGroupItem :id="`phone-${phone.id}`" :value="phone.id" />
            <Label :for="`phone-${phone.id}`" class="flex-1">
              <div class="flex justify-between items-center">
                <div>
                  <p class="font-medium">{{ phone.model_name }}</p>
                  <p class="text-sm text-gray-500">Cash Price: R{{ phone.cash_price.toFixed(2) }}</p>
                </div>
                <div v-if="store.riskProfile" class="text-right">
                  <p class="text-sm">Deposit: {{ (store.riskProfile.deposit * 100).toFixed(0) }}%</p>
                  <p class="text-sm">Interest: {{ (store.riskProfile.interest * 100).toFixed(0) }}%</p>
                </div>
              </div>
            </Label>
          </div>
        </RadioGroup>

        <div v-if="store.selectedPhone" class="mt-8 p-4 border rounded-md bg-gray-50">
          <h3 class="text-lg font-semibold mb-4">Selected Phone Details</h3>
          <div class="grid gap-2">
            <div class="flex justify-between">
              <span class="font-medium">Model:</span>
              <span>{{ store.selectedPhone.model_name }}</span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium">Risk Group:</span>
              <span>Age {{ store.applicantAge }} (Deposit: {{ (store.riskProfile?.deposit * 100).toFixed(0) }}%, Interest: {{ (store.riskProfile?.interest * 100).toFixed(0) }}%)</span>
            </div>
            <Separator />
            <div class="flex justify-between">
              <span class="font-medium">Loan Principal:</span>
              <span>R{{ store.loanPrincipal?.toFixed(2) }}</span>
            </div>
            <div class="flex justify-between">
              <span class="font-medium">Total Loan Amount:</span>
              <span>R{{ store.totalLoanAmount?.toFixed(2) }}</span>
            </div>
            <Separator />
            <div class="flex justify-between text-lg font-bold">
              <span>Daily Payment:</span>
              <span>R{{ store.dailyPayment?.toFixed(2) }}</span>
            </div>
          </div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>
