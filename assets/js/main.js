// Highlight the current page in the nav (header partial is generic)
(function () {
  var file = (location.pathname.split('/').pop() || '').toLowerCase();
  if (file === 'index.html') file = '';
  document.querySelectorAll('#primary-menu a').forEach(function (a) {
    var href = (a.getAttribute('href') || '');
    var hfile = href === '/' ? '' : href.split('/').pop().toLowerCase();
    if (hfile === file) {
      a.setAttribute('aria-current', 'page');
      a.classList.add('is-active');
      var mega = a.closest('.has-mega');
      if (mega) {
        var t = mega.querySelector('.mega-trigger');
        if (t) t.classList.add('is-active');
      }
    }
  });
})();

// Auto-build a table of contents from article H2s (nav.toc[data-auto])
(function () {
  var toc = document.querySelector('.toc[data-auto]');
  if (!toc) return;
  var heads = document.querySelectorAll('.article .container > h2');
  if (!heads.length) { toc.remove(); return; }
  var ol = document.createElement('ol');
  heads.forEach(function (h, i) {
    var id = h.id || (h.textContent.toLowerCase()
      .replace(/[^\w\s-]/g, '').trim().replace(/\s+/g, '-').slice(0, 60) || 'q' + i);
    h.id = id;
    var li = document.createElement('li');
    var a = document.createElement('a');
    a.href = '#' + id;
    a.textContent = h.textContent;
    li.appendChild(a);
    ol.appendChild(li);
  });
  toc.appendChild(ol);
})();

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
