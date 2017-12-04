//
//  ViewController.swift
//  Pokedex4
//
//  Created by Murat Kuran on 18/11/2017.
//  Copyright © 2017 Murat Kuran. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBtn: UISearchBar!
    
    var pokemonArr = [Pokemon]()
    var filterPokemonArr = [Pokemon]()
    
    var musicPlayer: AVAudioPlayer!
    
    var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.delegate = self
        collection.dataSource = self
        searchBtn.delegate = self
        
        searchBtn.returnKeyType = UIReturnKeyType.done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            let url = URL(string: path)!
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print (err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                
                let pokemonObj = Pokemon(name: pokeName, pokedexId: pokeId)
                pokemonArr.append(pokemonObj)
            }
            
            
        } catch let err as NSError {
            print (err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchMode{
            return filterPokemonArr.count
        }
        return pokemonArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            
            if isSearchMode {
                poke = filterPokemonArr[indexPath.row]
            }
            else {
                poke = pokemonArr[indexPath.row]
            }
            
            cell.configureCell(pokemon: poke)
        
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if isSearchMode {
            poke = filterPokemonArr[indexPath.row]
        }
        else {
            poke = pokemonArr[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetail", sender: poke)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != nil && searchBar.text != "" {
            isSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filterPokemonArr = pokemonArr.filter({$0.name.range(of: lower) != nil}) //Filter pokemon array
            collection.reloadData()
        }
        else {
            isSearchMode = false
            view.endEditing(true) //Close keyboard when there is no text in search bar
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true) // Close keyboard when done button is clicked
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetail" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    




}

