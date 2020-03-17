import "bootstrap";

const load = document.getElementById("load");
const unload = document.getElementById("unload");


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


const request = (url, cat) => {
  fetch(url, {
    method: "POST",
    body: JSON.stringify({ cat })
  })
    .then(response => response.json())
    .then((data) => {
      console.log(data);
    });
}

const option = () => {
  const category = document.getElementById("categories").value;
  const url = "http://localhost:3000"
  request(url, category);
}


categories.addEventListener('change', option);


// const option = document.querySelector(".select-tag")
// const optionText = option.innerHTML

// if (optionText) {
//   optionText.addEventListener("click", () => {
//     console.log("I clicked");
//   })
// }
