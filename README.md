# ENIGMA

## Self Assessment

### Functionality ( 4 / 4 )
Cracking method and command line interface successfully implements. Main area for improvement in functionality would be a refactor on the `#find_key`. Currently, it uses brute force to go through all 100K possible keys, but it could be improved by looking through a smaller selection of possible keys.

### Object Oriented Programming ( 3 / 4 )
I think I did pretty well on this but I struggled for quite a while determining best organizational method for this project.
Originally, I did not have encrypter, decrypter, and cracker broken out into individual classes breaking them out has improved SRP. If I had more time I would probably create a parent class for `encrypter.rb` and `decrypter.rb`.

### Ruby Conventions & Mechanics ( 4 / 4 )
Overall sticks very well to conventions/mechanics/proper syntax. All methods are below 10 lines.

### Test Driven ( 3 / 4 )
Everything is tested at unit and integration level and tested all edge cases I could think of. Test coverage is at 100%. I would improve on this area by adding in mocks/stubs to improve test speed. 

### Version Control ( 3 / 4 )
I thought I did really well with version control well over 40 commits and 4 pull requests, but there were some branch names that weren't super accurate. And I would be interested to know if I'm over doing it on PRs/commits since I went so far over the mark for getting 4 in this section.

#### Overall grade ( 3.4 / 4 )