window.onload = (event) => {


    var url = new URL(window.location.href).pathname;
    var element = document.getElementsByClassName("header")[0];


    if(url === "/getting-started.php" || url == "/best-practices.php" || url == "/manual.php" || url == "/99-problems.php" || url == "/blog.php" || url == "/learn.php") {
      element.classList.add("wide");
    }



  var swiper = new Swiper(".mySwiper", {
    loop: false,
    spaceBetween: 10,
    slidesPerView: 3,
    freeMode: true,
    watchSlidesProgress: true,
  });


  var swiper = new Swiper(".testimonials-swiper", {
    loop: true,
    spaceBetween: 32,
    watchSlidesProgress: true,
    breakpoints: {
      640: {
        slidesPerView: 1
      },
      768: {
        slidesPerView: 2
      },
      1024: {
        slidesPerView: 3
      },
    }
  });

  var swiper2 = new Swiper(".mySwiper2", {
    loop: true,
    autoplay: { delay: 5000, disableOnInteraction: false, },
    spaceBetween: 10,
    thumbs: {
      swiper: swiper,
    },
  });
};

