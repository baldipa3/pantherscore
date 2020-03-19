import "bootstrap";

const load = document.getElementById("load");
const unload = document.getElementById("unload");

// Reviews counter
const up = document.querySelector(".fa-thumbs-up")
const down = document.querySelector(".fa-thumbs-up")

if (up) {
  up.addEventListener("click", () => {
  if (up.innerText >= 0) {
    let counter = 0
    let newCounter = counter + 1
    up.insertAdjacentText("beforeend", newCounter)
  }
  });
}


if (load) {
  load.addEventListener("click", () => {
    const containers = document.querySelectorAll(".d-none");
    containers.forEach((container) => {
      container.classList.remove("d-none");
    });
    load.classList.add("d-none");
    unload.classList.remove("d-none");
  });
}


if (unload) {
  unload.addEventListener("click", () => {
    const containerRecommends = Array.from(document.querySelectorAll(".container-recommend"));
    containerRecommends.forEach((container) => {
      let index = containerRecommends.indexOf(container)
      if (index > 4) {
        container.classList.add("d-none");
      }
    });
    unload.classList.add("d-none");
    load.classList.remove("d-none")
  });
}
