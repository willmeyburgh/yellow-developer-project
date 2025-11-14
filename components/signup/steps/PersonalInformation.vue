<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useLoanApplicationStore } from '~/stores/loanApplication';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

const store = useLoanApplicationStore();

const fullName = ref(store.full_name);
const saIdNumber = ref(store.sa_id_number);

// Validation states
const fullNameError = ref('');
const saIdError = ref('');
const ageError = ref('');

// Watch for changes and update store
watch(fullName, (newValue) => {
  store.full_name = newValue;
  if (newValue.length < 3) {
    fullNameError.value = 'Full Name must be at least 3 characters.';
  } else {
    fullNameError.value = '';
  }
});

watch(saIdNumber, async (newValue) => { // Made async to await checkExistingApplication
  store.sa_id_number = newValue;
  if (newValue.length !== 13 || !/^\d+$/.test(newValue)) {
    saIdError.value = 'SA ID Number must be 13 digits.';
    store.birthday = null; // Clear birthday if SA ID is invalid
    store.existingApplicationId = null; // Clear existing application ID
  } else {
    // Trigger store's SA ID validation
    if (!store.isSaIdValid) {
      saIdError.value = 'Invalid SA ID Number (checksum or date).';
      ageError.value = '';
      store.birthday = null;
      store.existingApplicationId = null; // Clear existing application ID
    } else {
      saIdError.value = '';
      // Update birthday in store, which will trigger age calculation
      // The store's setPersonalInformation action handles this
      store.setPersonalInformation(fullName.value, newValue);

      if (!store.isAgeValid) {
        ageError.value = 'Applicant must be between 18 and 65 years old.';
      } else {
        ageError.value = '';
      }
      // Check for existing application after SA ID is valid
      await store.checkExistingApplication(newValue);
    }
  }
});

// Update local refs if store values change (e.g., on form reset)
watch(() => store.full_name, (newValue) => {
  fullName.value = newValue;
});
watch(() => store.sa_id_number, (newValue) => {
  saIdNumber.value = newValue;
});

const isStepValid = computed(() => {
  return fullName.value.length >= 3 &&
         saIdNumber.value.length === 13 &&
         /^\d+$/.test(saIdNumber.value) &&
         store.isSaIdValid &&
         store.isAgeValid;
});

// Expose validation status for parent component
defineExpose({
  isStepValid,
});
</script>

<template>
  <Card class="w-full max-w-md mx-auto">
    <CardHeader>
      <CardTitle>Personal Information</CardTitle>
      <CardDescription>Please provide your personal details.</CardDescription>
    </CardHeader>
    <CardContent>
      <div class="grid gap-4">
        <div class="grid gap-2">
          <Label for="fullName">Full Name</Label>
          <Input id="fullName" v-model="fullName" type="text" placeholder="John Doe" />
          <p v-if="fullNameError" class="text-red-500 text-sm">{{ fullNameError }}</p>
        </div>
        <div class="grid gap-2">
          <Label for="saIdNumber">SA ID Number</Label>
          <Input id="saIdNumber" v-model="saIdNumber" type="text" placeholder="YYMMDDXXXXXXXXX" maxlength="13" />
          <p v-if="saIdError" class="text-red-500 text-sm">{{ saIdError }}</p>
          <p v-if="ageError" class="text-red-500 text-sm">{{ ageError }}</p>
          <p v-if="store.existingApplicationId" class="text-orange-500 text-sm">
            An application with this SA ID already exists. Submitting again will override the previous application.
          </p>
        </div>
        <div v-if="store.birthday" class="grid gap-2">
          <Label>Birthday</Label>
          <Input :model-value="store.birthday" type="text" readonly class="bg-gray-100" />
        </div>
      </div>
    </CardContent>
  </Card>
</template>