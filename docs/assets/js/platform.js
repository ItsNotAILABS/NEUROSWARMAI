/* CHIMERIA Defense Systems — Platform JavaScript */

// Mobile navigation toggle
document.addEventListener('DOMContentLoaded', function() {
  const toggle = document.querySelector('.nav-toggle');
  const links = document.querySelector('.nav-links');
  if (toggle && links) {
    toggle.addEventListener('click', function() {
      links.style.display = links.style.display === 'flex' ? 'none' : 'flex';
      links.style.flexDirection = 'column';
      links.style.position = 'absolute';
      links.style.top = '64px';
      links.style.left = '0';
      links.style.right = '0';
      links.style.background = 'rgba(5,5,8,0.98)';
      links.style.padding = '16px 24px';
      links.style.borderBottom = '1px solid var(--border)';
    });
  }

  // Animate stat numbers on scroll
  const statValues = document.querySelectorAll('.stat-value');
  if (statValues.length > 0) {
    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          animateValue(entry.target);
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.5 });
    statValues.forEach(function(el) { observer.observe(el); });
  }

  // Tab switching
  document.querySelectorAll('.tab').forEach(function(tab) {
    tab.addEventListener('click', function() {
      var group = this.closest('.tabs');
      group.querySelectorAll('.tab').forEach(function(t) { t.classList.remove('active'); });
      this.classList.add('active');
      var target = this.getAttribute('data-tab');
      if (target) {
        document.querySelectorAll('.tab-panel').forEach(function(p) {
          p.style.display = p.id === target ? 'block' : 'none';
        });
      }
    });
  });
});

function animateValue(el) {
  var text = el.textContent;
  var num = parseFloat(text.replace(/[^0-9.]/g, ''));
  if (isNaN(num)) return;
  var suffix = text.replace(/[0-9.,]/g, '');
  var duration = 1200;
  var start = 0;
  var startTime = null;
  function step(timestamp) {
    if (!startTime) startTime = timestamp;
    var progress = Math.min((timestamp - startTime) / duration, 1);
    var current = Math.floor(progress * num);
    el.textContent = current.toLocaleString() + suffix;
    if (progress < 1) {
      requestAnimationFrame(step);
    } else {
      el.textContent = text;
    }
  }
  requestAnimationFrame(step);
}
