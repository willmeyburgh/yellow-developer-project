<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useLoanApplicationStore } from '~/stores/loanApplication';
import PersonalInformation from './steps/PersonalInformation.vue';
import IncomeDetails from './steps/IncomeDetails.vue';
import PhoneSelection from './steps/PhoneSelection.vue';
import ReviewAndSubmit from './steps/ReviewAndSubmit.vue';
import ThankYou from './steps/ThankYou.vue'; // Import the new ThankYou component
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';

const store = useLoanApplicationStore();

const personalInfoRef = ref<InstanceType<typeof PersonalInformation> | null>(null);
const incomeDetailsRef = ref<InstanceType<typeof IncomeDetails> | null>(null);
const phoneSelectionRef = ref<InstanceType<typeof PhoneSelection> | null>(null);
const reviewAndSubmitRef = ref<InstanceType<typeof ReviewAndSubmit> | null>(null);
const thankYouRef = ref<InstanceType<typeof ThankYou> | null>(null); // Ref for ThankYou component

const currentStepComponent = computed(() => {
  switch (store.currentStep) {
    case 1: return PersonalInformation;
    case 2: return IncomeDetails;
    case 3: return PhoneSelection;
    case 4: return ReviewAndSubmit;
    case 5: return ThankYou; // Add ThankYou component for step 5
    default: return PersonalInformation;
  }
});

const isCurrentStepValid = computed(() => {
  switch (store.currentStep) {
    case 1: return personalInfoRef.value?.isStepValid ?? false;
    case 2: return incomeDetailsRef.value?.isStepValid ?? false;
    case 3: return phoneSelectionRef.value?.isStepValid ?? false;
    case 4: return reviewAndSubmitRef.value?.isStepValid ?? false;
    case 5: return true; // ThankYou page is always valid to display
    default: return false;
  }
});

const progressValue = computed(() => {
  return (store.currentStep / 5) * 100; // Updated for 5 steps
});

const handleNext = async () => { // Made async to await submission
  if (isCurrentStepValid.value) {
    if (store.currentStep === 4) {
      await store.submitApplication(); // Submit application
      if (store.status === 'SUBMITTED') {
        store.nextStep(); // Move to Thank You page only if submission is successful
      }
    } else {
      store.nextStep();
    }
  }
};

const handleBack = () => {
  store.prevStep();
};

onMounted(() => {
  store.fetchPhoneModels();
});
</script>

<template>
  <div class="container mx-auto p-4 max-w-2xl">
    <div class="text-center mb-6">
      <h1 class="text-2xl font-bold">Loan Application Form</h1>
      <p class="text-gray-600">Complete the 5 steps to apply for your loan.</p>
    </div>

    <div class="mb-6">
      <Progress :model-value="progressValue" class="w-full" />
      <p class="text-center text-sm mt-2">Step {{ store.currentStep }} of 5</p>
    </div>

    <component
      :is="currentStepComponent"
      :ref="(el) => {
        if (store.currentStep === 1) personalInfoRef = el;
        if (store.currentStep === 2) incomeDetailsRef = el;
        if (store.currentStep === 3) phoneSelectionRef = el;
        if (store.currentStep === 4) reviewAndSubmitRef = el;
        if (store.currentStep === 5) thankYouRef = el; // Assign ref for ThankYou
      }"
    />

    <div class="flex justify-between mt-6">
      <Button
        v-if="store.currentStep > 1 && store.currentStep < 5 && store.status !== 'SUBMITTED'"
        variant="outline"
        @click="handleBack"
      >
        Back
      </Button>
      <div v-else></div>
      <Button
        v-if="store.currentStep < 5"
        @click="handleNext"
        :disabled="!isCurrentStepValid || store.status === 'SUBMITTING'"
      >
        {{ store.currentStep === 4 ? (store.status === 'SUBMITTING' ? 'Submitting...' : 'Submit') : 'Next' }}
      </Button>
      <!-- No button for step 5 (Thank You page) -->
    </div>
  </div>
</template>