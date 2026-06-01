window.addEventListener("load", (e) => {
  if (!window.web3 && !window.ethereum) {
    throw new Error("Please install MetaMask");
  }

  if (window.ethereum) {
    let myaccounts;

    window.ethereum
      .request({ method: "eth_requestAccounts" })
      .then((accounts) => {
        myaccounts = accounts;
        window.web3 = new Web3(window.ethereum);
      })
      .catch((err) => {
        console.error("Failed to request account access: ", err);
      });
  }
});

// 监听账户变化
window.ethereum.on("accountsChanged", (accounts) => {
  console.log("Accounts changed: ", accounts);
  window.web3 = new Web3(window.ethereum);
});

// 监听网络变化
window.ethereum.on("chainChanged", (chainId) => {
  console.log("Chain changed: ", chainId);
  window.location.reload();
});

let owner_abi = document.getElementById("owner-value").value;
function getOwner() {
  let contractAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";
  let OwnerFactory = new web3.eth.Contract(owner_abi, contractAddress);
  ZombieFactory.methods.getOwner().call((err, res) => {
    if (err) {
      console.error("An error occured", err);
    }
    console.log("The owner is: ", res);
  });
}
function getReceiver() {
  console.log("getReceiver");
}

function changeOwner() {
  owner_abi = document.getElementById("owner-value").value;
}
