<script>
  // Initialize the current slide index and select all carousel slides
  let currentIndex = 0;
  const slides = document.querySelectorAll('.carousel-slide');
  const totalSlides = slides.length;

  // Function to change slide based on the index
  function showSlide(index) {
    // Reset all slides to default position
    slides.forEach((slide, i) => {
      slide.style.transform = `translateX(${(i - index) * 100}%)`;
    });
  }

  // Next slide function (forward)
  function nextSlide() {
    currentIndex = (currentIndex + 1) % totalSlides;
    showSlide(currentIndex);
  }

  // Previous slide function (backward)
  function prevSlide() {
    currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
    showSlide(currentIndex);
  }

  // Set interval to automatically move to the next slide every 3 seconds
  setInterval(nextSlide, 7000); // Change to 3000ms (3 seconds) for better timing

  // Navigation buttons (optional)
  const nextButton = document.querySelector('.next');
  const prevButton = document.querySelector('.prev');

  // Only add event listeners if the buttons are found
  if (nextButton) {
    nextButton.addEventListener('click', nextSlide);
  }
  if (prevButton) {
    prevButton.addEventListener('click', prevSlide);
  }

  // Initially show the first slide
  showSlide(currentIndex);
</script>
