// Mobile nav toggle
const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.nav');
if (toggle && nav) {
  toggle.addEventListener('click', () => {
    const open = nav.classList.toggle('open');
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  });
}

// Mega menu: click/keyboard toggle (hover handled by CSS on desktop)
document.querySelectorAll('.has-mega').forEach((mega) => {
  const trigger = mega.querySelector('.mega-trigger');
  if (!trigger) return;
  trigger.addEventListener('click', (e) => {
    e.preventDefault();
    const open = mega.getAttribute('aria-expanded') === 'true';
    mega.setAttribute('aria-expanded', open ? 'false' : 'true');
    trigger.setAttribute('aria-expanded', open ? 'false' : 'true');
  });
  // Close on outside click
  document.addEventListener('click', (e) => {
    if (!mega.contains(e.target)) {
      mega.setAttribute('aria-expanded', 'false');
      trigger.setAttribute('aria-expanded', 'false');
    }
  });
  // Close on Escape
  mega.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
      mega.setAttribute('aria-expanded', 'false');
      trigger.setAttribute('aria-expanded', 'false');
      trigger.focus();
    }
  });
});
