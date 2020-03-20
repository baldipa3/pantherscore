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

const results = document.querySelector("#js-select");
const categoryHome = document.querySelector(".cathome");
const none = document.querySelector(".remove");



const request = (url) => {
  none.classList.add("d-none")
  jQuery('#js-select').html('');
  fetch(url)
    .then(response => response.json())
    .then((data) => {
      data.forEach((element, index) => {
        let li = ``
        if (index > 4) {
          li = `<li class="d-none container-recommend">`
        } else {
          li = `<li class="container-recommend">`
        }

        const divs = `<div class="container-flex">
                      <div class="card-service">
                      <div class="card-score">
                      <svg width="55" height="55" viewBox="0 0 74 74" fill="none" xmlns="http://www.w3.org/2000/svg">`

        let panter = ``
        if (element.pantherscore <= 39) {
        panter = `<path d="M61.0651 65.3803C40.3322 76.0751 13.5042 66.3695 3.30462 44.6461C-3.43328 30.3288 0.510549 12.7226 11.6992 6.6396C17.7818 3.35081 30.9486 5.15593 43.1263 10.7444C75.0478 25.7294 84.2584 53.6965 61.0651 65.3803Z" fill="#FF5252"/>`
        } else if (element.pantherscore > 47 && element.pantherscore < 74) {
        panter = `<path d="M61.0651 65.3803C40.3322 76.0751 13.5042 66.3695 3.30462 44.6461C-3.43328 30.3288 0.510549 12.7226 11.6992 6.6396C17.7818 3.35081 30.9486 5.15593 43.1263 10.7444C75.0478 25.7294 84.2584 53.6965 61.0651 65.3803Z" fill="#FFC048"/>`
        } else {
        panter = `<path d="M61.0651 65.3803C40.3322 76.0751 13.5042 66.3695 3.30462 44.6461C-3.43328 30.3288 0.510549 12.7226 11.6992 6.6396C17.7818 3.35081 30.9486 5.15593 43.1263 10.7444C75.0478 25.7294 84.2584 53.6965 61.0651 65.3803Z" fill="#33D9B2"/>`
        }

        const rest = `<text class="score-text" x="20" y="44" fill="white">${element.pantherscore}</text>
                      </svg>
                      </div>
                      <div class="card-service-icon ml-4">
                      <img class='icon-large' src='${element.icon}'>
                      </div>
                      <div class="card-service-info ml-4">
                      <a href='http://localhost:3000/services/${element.id}'>${element.name}</a>
                      <div>
                      <p class="line-clamp-users">${element.description}</p>
                      </div>
                      </div>
                      </div>
                      </div>
                      </li>`
      const service = li.concat(divs, panter, rest)
      if (results !== null) {
        results.insertAdjacentHTML("beforeend", service);
      }
      none.classList.remove("d-none")
      });
    });
};

const option = (event) => {
  const category = encodeURIComponent((event.currentTarget.options[event.currentTarget.selectedIndex].value));
  const url = `http://localhost:3000/services/query?category=${category}`;
  request(url);
}

const home = (event) => {
  console.log(event)
  window.location.href='http://localhost:3000/services'
  const category = encodeURIComponent();
  const url = `http://localhost:3000/services/query?category=${category}`;
  request(url);
}

if (results) {
  categories.addEventListener('change', option);
};

if (categoryHome) {
  categoryHome.addEventListener('click', home);
};

