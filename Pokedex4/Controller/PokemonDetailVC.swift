//
//  PokemonDetailVC.swift
//  Pokedex4
//
//  Created by Murat Kuran on 19/11/2017.
//  Copyright © 2017 Murat Kuran. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            
            // Whatever we write will only be called after the network call is complete
            print("Did we arrive here?")
            self.updateUI()
            
        }
    }
    
    func updateUI(){
        defenseLbl.text = pokemon.defense
        attackLbl.text = pokemon.attack
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.evoId == "" || pokemon.evoId == "\(pokemon.pokedexId)" {
            self.evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }
        else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.evoId)
            let str = "Next Evolution: \(pokemon.evoName) - LVL \(pokemon.evoLevel)"
            self.evoLbl.text = str
        }
    }
}
