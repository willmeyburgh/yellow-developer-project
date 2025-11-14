<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useLoanApplicationStore } from '~/stores/loanApplication';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const store = useLoanApplicationStore();

const monthlyIncome = ref(store.monthly_income);
const proofDocument = ref<File | null>(null); // To hold the selected file object
const proofDocumentName = ref(store.proof_document_name); // To display the file name

// Validation states
const monthlyIncomeError = ref('');
const proofDocumentError = ref('');

watch(monthlyIncome, (newValue) => {
  store.monthly_income = newValue;
  if (newValue === null || newValue <= 0) {
    monthlyIncomeError.value = 'Monthly Income must be a positive value.';
  } else {
    monthlyIncomeError.value = '';
  }
});

const handleFileUpload = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    proofDocument.value = target.files[0];
    proofDocumentName.value = target.files[0].name;
    store.setProofDocumentName(target.files[0].name);
    proofDocumentError.value = '';
  } else {
    proofDocument.value = null;
    proofDocumentName.value = null;
    store.setProofDocumentName('');
    proofDocumentError.value = 'Proof Document is required.';
  }
};

// Update local refs if store values change (e.g., on form reset)
watch(() => store.monthly_income, (newValue) => {
  monthlyIncome.value = newValue;
});
watch(() => store.proof_document_name, (newValue) => {
  proofDocumentName.value = newValue;
});


const isStepValid = computed(() => {
  return monthlyIncome.value !== null &&
         monthlyIncome.value > 0 &&
         proofDocumentName.value !== null &&
         proofDocumentName.value !== '';
});

// Expose validation status for parent component
defineExpose({
  isStepValid,
});
</script>

<template>
  <Card class="w-full max-w-md mx-auto">
    <CardHeader>
      <CardTitle>Income Details</CardTitle>
      <CardDescription>Please provide your monthly income and proof of income.</CardDescription>
    </CardHeader>
    <CardContent>
      <div class="grid gap-4">
        <div class="grid gap-2">
          <Label for="monthlyIncome">Monthly Income (ZAR)</Label>
          <Input id="monthlyIncome" v-model.number="monthlyIncome" type="number" placeholder="e.g., 15000" />
          <p v-if="monthlyIncomeError" class="text-red-500 text-sm">{{ monthlyIncomeError }}</p>
        </div>
        <div class="grid gap-2">
          <Label for="proofDocument">Proof Document</Label>
          <Input id="proofDocument" type="file" @change="handleFileUpload" accept=".pdf,.jpg,.png" />
          <p v-if="proofDocumentName">Selected: {{ proofDocumentName }}</p>
          <p v-if="proofDocumentError" class="text-red-500 text-sm">{{ proofDocumentError }}</p>
        </div>
      </div>
    </CardContent>
  </Card>
</template>
