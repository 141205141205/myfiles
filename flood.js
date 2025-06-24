const Kahoot = require("@venixthedev/kahootjs");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const red = (text) => `\x1b[31m${text}\x1b[0m`;

function ask(question) {
  return new Promise((resolve) => {
    rl.question(red(question), (answer) => {
      if (answer.toLowerCase() === "q") {
        console.log(red("Quitting..."));
        rl.close();
        process.exit();
      }
      resolve(answer);
    });
  });
}

async function start() {
  const gamePin = await ask("Enter Game PIN: ");
  const prefix = await ask("Enter Bot Name: ");
  let count = await ask("(l: q:)How many bots?: ");
  
  if (count.toLowerCase() === 'l') {
    console.log(red("Starting loop"));
    while (true) {
      await joinBots(gamePin, prefix);
    }
  } else {
    count = parseInt(count);
    if (isNaN(count) || count < 1 ) {
      console.log(red("error"));
      return start();
    }

    for (let i = 0; i < count; i++) {
      await joinBots(gamePin, prefix);
    }
  }

  rl.close();
}

let botCounter = 1;
async function joinBots(gamePin, prefix) {
  const name = `${prefix}${botCounter++}`;
  const client = new Kahoot();
  
  client.join(gamePin, name)
    .then(() => console.log(red(`Bot joined: ${name}`)))
    .catch(() => console.log(red(`Failed to join: ${name}`)));


  await new Promise(resolve => setTimeout(resolve, 55));
}

start();
