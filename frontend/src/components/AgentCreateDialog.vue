<script setup lang="ts">
import { ref, computed } from 'vue'
import { api } from '@/api/client'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'

const props = defineProps<{
  open: boolean
  space: string
}>()

const emit = defineEmits<{
  'update:open': [value: boolean]
  created: [agentName: string]
}>()

const agentName = ref('')
const workDir = ref('')
const backend = ref<'tmux' | 'ambient'>('tmux')
const submitting = ref(false)
const errorMsg = ref('')

const isTmux = computed(() => backend.value === 'tmux')

function reset() {
  agentName.value = ''
  workDir.value = ''
  backend.value = 'tmux'
  errorMsg.value = ''
}

async function submit() {
  const name = agentName.value.trim()
  if (!name) return
  submitting.value = true
  errorMsg.value = ''
  try {
    await api.createAgent(props.space, {
      name,
      work_dir: isTmux.value ? (workDir.value.trim() || undefined) : undefined,
      backend: backend.value,
    })
    const created = name
    reset()
    emit('created', created)
    emit('update:open', false)
  } catch (e: unknown) {
    errorMsg.value = e instanceof Error ? e.message : String(e)
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <Dialog :open="open" @update:open="(v) => { if (!v) reset(); emit('update:open', v) }">
    <DialogContent class="sm:max-w-[440px]">
      <DialogHeader>
        <DialogTitle>Add Agent</DialogTitle>
        <DialogDescription>
          Spawn a new agent in <span class="font-medium">{{ space }}</span>.
        </DialogDescription>
      </DialogHeader>

      <form class="flex flex-col gap-4 py-2" @submit.prevent="submit">
        <!-- Agent Name -->
        <div class="flex flex-col gap-1.5">
          <label class="text-xs font-medium text-muted-foreground uppercase tracking-wide">
            Agent Name <span class="text-destructive">*</span>
          </label>
          <Input
            v-model="agentName"
            placeholder="e.g. MyAgent"
            autocomplete="off"
            required
          />
        </div>

        <!-- Backend selector -->
        <div class="flex flex-col gap-1.5">
          <label class="text-xs font-medium text-muted-foreground uppercase tracking-wide">Backend</label>
          <div class="flex gap-2">
            <button
              type="button"
              :class="[
                'flex-1 rounded border px-3 py-1.5 text-sm transition-colors',
                backend === 'tmux'
                  ? 'border-primary bg-primary/10 text-primary font-medium'
                  : 'border-border bg-background hover:bg-muted/50',
              ]"
              @click="backend = 'tmux'"
            >
              tmux
            </button>
            <button
              type="button"
              :class="[
                'flex-1 rounded border px-3 py-1.5 text-sm transition-colors',
                backend === 'ambient'
                  ? 'border-primary bg-primary/10 text-primary font-medium'
                  : 'border-border bg-background hover:bg-muted/50',
              ]"
              @click="backend = 'ambient'"
            >
              ambient
            </button>
          </div>
          <p class="text-xs text-muted-foreground">
            <template v-if="isTmux">Local tmux session on the coordinator host.</template>
            <template v-else>Remote Kubernetes pod via the Ambient Code Platform.</template>
          </p>
        </div>

        <!-- Working Directory (tmux only) -->
        <div v-if="isTmux" class="flex flex-col gap-1.5">
          <label class="text-xs font-medium text-muted-foreground uppercase tracking-wide">
            Working Directory (optional)
          </label>
          <Input
            v-model="workDir"
            placeholder="e.g. /home/user/my-project"
            autocomplete="off"
            class="font-mono text-sm"
          />
          <p class="text-xs text-muted-foreground">
            The agent's tmux session will <code>cd</code> to this directory before starting.
          </p>
        </div>

        <p v-if="errorMsg" class="text-xs text-destructive">{{ errorMsg }}</p>

        <DialogFooter>
          <Button type="button" variant="outline" @click="emit('update:open', false)">Cancel</Button>
          <Button type="submit" :disabled="!agentName.trim() || submitting">
            {{ submitting ? 'Creating…' : 'Add Agent' }}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  </Dialog>
</template>
