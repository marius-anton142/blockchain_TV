## Generic info

## Contacts
Inside the contracts folder, the `final` folder can be found, importing that folder inside Remix online IDE and the contracts are ready to deploy

During the contract implementation we followed :
  * utilizarea tipurilor de date specifice Solidity (mappings, address).
  * înregistrarea de events.
  * utilizarea de modifiers.
  * exemple pentru toate tipurile de funcții (external, pure, view etc.)
  * exemple de transfer de eth.
  * ilustrarea interacțiunii dintre smart contracte.
  * deploy pe o rețea locală sau pe o rețea de test Ethereum.
  * utilizarea de Oracles
  * utilizare librării
  * implementarea de teste (cu tool-uri la alegerea echipelor).

## Web Interface
The web interface is inside the frontend folder
We used  `http-server -p 8000` to open a port to load the web app, without it, the conncetion to MetaMask and to the contract was imposible
The web app has soled the fallowing :
  * Utilizarea unei librării web3 (exemple web3 sau ethersjs) și conectarea cu un Web3 Provider pentru accesarea unor informații generale despre conturi (adresa, balance).
  * Inițierea tranzacțiilor de transfer sau de apel de funcții, utilizând clase din librăriile web3.
  * Tratare events (Observer Pattern).
  * Analiza gas-cost (estimare cost și fixare limită de cost).
  * Control al stării tranzacțiilor (tratare excepții)

## Tests using Truffle
To run the test use `truffle test`
