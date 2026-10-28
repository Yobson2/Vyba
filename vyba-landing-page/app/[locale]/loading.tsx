export default function Loading() {
  return (
    <div
      className="flex min-h-[60vh] items-center justify-center"
      role="status"
      aria-label="Chargement"
    >
      <span className="relative flex size-3">
        <span className="animate-live-ping bg-primary absolute inset-0 rounded-full" />
        <span className="bg-primary relative size-3 rounded-full" />
      </span>
    </div>
  );
}
