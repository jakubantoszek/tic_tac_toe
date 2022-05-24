class Game{
    private var size = 3;
    private var board = [[Int]]();
    private var players = [Player]();
    private var curPlayer = 0;
    
    init(_ size: Int){
        self.size = size;
        for _ in 0...size-1 {
            var wiersz = [Int]();
            for _ in 0...size-1 {
                wiersz.append(-1);
            }
            board.append(wiersz)
        }
    }
    
    private func drawBoard(){
        let size = self.size;
        for i in 0...size-1 {
            print("|", terminator: " ");
            for j in 0...size-1 {
                if(self.board[i][j] == -1){
                    print(" ", terminator: " | ");
                }
                else if(self.board[i][j] == 0){
                    print(self.players[0].getSign(), terminator: " | ");
                }
                else{
                    print(self.players[1].getSign(), terminator: " | ");
                }
            }
            print("");
        }
    }
    
    private func clearBoard(){
        let size = self.size;
        for i in 0...size-1 {
            for j in 0...size-1 {
                self.board[i][j] = -1;
            }
        }
    }
    
    public func start(){
        if(players.count == 2){
            print("Wciśnij enter aby zacząć grę")
            readLine()
            
            let wynik = gameLoop();
            if(wynik == -1){
                print("Remis");
            }
            else{
                print("Wygrał: ", terminator: "");
                print(self.players[wynik].getSign());
            }
            
            print();
            print("Wpisz T, aby zacząć nową grę lub dowolny znak, aby zakończyć");
            let ifNew = readLine();
            if(ifNew! == "T"){
                print();
                self.curPlayer = (self.curPlayer + 1) % 2;
                self.clearBoard();
                self.start();
            }
            else{
                print("Koniec gry")
            }
        }
        else{
            print("Nie ma wystarczającej liczby graczy");
        }
    }
    
    private func gameLoop() -> Int{
        var turnNo = 0;
        var current = self.curPlayer;
        
        while(true){
            self.board = self.players[current].move(self.board, current, self.size);
            turnNo += 1;
            print();
            drawBoard();
            print();
            
            if(isOver(current)){
                return current;
            }
            else if(turnNo == self.size * self.size){
                return -1;
            }
            current = (current+1) % 2;
        }
    }
    
    private func isOver(_ p: Int) -> Bool{
        let s = self.size - 1;
        var x = 0;
        var y = 0;
        for i in 0...s {
            x = 0;
            y = 0;
            for j in 0...s {
                if(self.board[i][j] == p){
                    x += 1;
                }
                if(self.board[j][i] == p){
                    y += 1;
                }
            }
            if(x == self.size || y == self.size){
                return true;
            }
        }
        
        x = 0;
        y = 0;
        for i in 0...s {
            if(self.board[i][i] == p){
                x += 1;
            }
            if(self.board[i][s-i] == p){
                y += 1;
            }
        }
        if(x == self.size || y == self.size){
            return true;
        }
        else{
            return false;
        }
    }
    
    public func addPlayer(_ p: Player){
        if(self.players.count < 2){
            self.players.append(p);
        }
    }
}

class Player{
    private var sign = "x";
    
    init(_ sign: String){
        self.sign = sign;
    }
    
    public func move(_ b: [[Int]], _ no: Int, _ size: Int) -> [[Int]]{
        return b;
    }
    
    public func getSign() -> String{
        return self.sign;
    }
}

class UserPlayer : Player{
    private var sign = "x";
    
    override init(_ sign: String){
        self.sign = sign;
        super.init(sign);
    }
    
    override func move(_ b: [[Int]], _ no: Int, _ size: Int) -> [[Int]]{
        var board = b;
        print("Aktualny gracz: ", terminator: "");
        print(self.sign);
        while(true){
            print("Wybierz wiersz: ", terminator: "");
            let w = readLine();
            print("Wybierz kolumnę: ", terminator: "");
            let k = readLine();
            let wi:Int? = Int(w!);
            let ko:Int? = Int(k!);
            
            if(wi! <= size && ko! <= size && wi! > 0 && ko! > 0){
                if(board[wi! - 1][ko! - 1] == -1){
                    board[wi! - 1][ko! - 1] = no;
                    break;
                }
                else{
                    print("Pole zajęte. Wybierz inne pole");
                    print();
                }
            }
            else{
                print("Pole nie mieści się na planszy");
                print();
            }
        }
        return board;
    }
}

class EasyAIPlayer : Player{
    private var sign = "x";
    
    override init(_ sign: String){
        self.sign = sign;
        super.init(sign);
    }
    
    override func move(_ b: [[Int]], _ no: Int, _ size: Int) -> [[Int]]{
        var board = b;
        print("Aktualny gracz: ", terminator: "");
        print(self.sign);
        
        var arr = [[Int]]();
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(board[i][j] == -1){
                    arr.append([i, j]);
                }
            }
        }
        
        let ct = arr.count
        if(ct <= size * size){
            let x = Int.random(in: 1...ct);
            let wi = arr[x - 1][0]
            let ko = arr[x - 1][1]
            
            board[wi][ko] = no;
        }
        
        return board;
    }
}

class MediumAIPlayer : Player{
    private var sign = "x";
    
    override init(_ sign: String){
        self.sign = sign;
        super.init(sign);
    }
    
    
    override func move(_ b: [[Int]], _ no: Int, _ size: Int) -> [[Int]]{
        var board = b;
        print("Aktualny gracz: ", terminator:"");
        print(self.sign);
        
        for i in 0...size-1 {
            var x1 = 0;
            var y1 = 0;
            var x2 = 0;
            var y2 = 0;
            
            for j in 0...size-1 {
                if(board[i][j] == no){
                    x1 += 1;
                } 
                else if(board[i][j] != -1){
                    y1 += 1;
                }
                
                if(board[j][i] == no) {
                    x2 += 1;
                }
                else if(board[j][i] != -1){
                    y2 += 1;
                }
            }
            
            if(x1 == size-1 || y1 == size-1){
                for j in 0...size-1 {
                    if(board[i][j] == -1){
                        board[i][j] = no;
                        return board;
                    }
                }
            }
                
            if(x2 == size-1 || y2 == size-1){
                for j in 0...size-1 {
                    if(board[j][i] == -1){
                        board[j][i] = no;
                        return board;
                    }
                }
            }
        }
        
        var x1 = 0;
        var y1 = 0;
        var x2 = 0;
        var y2 = 0;
        let s = size-1;
            
        for i in 0...s{
                
            if(board[i][i] == no){
                x1 += 1;
            }
            else if(board[i][i] != -1){
                y1 += 1;
            }
                
            if(board[i][s-i] == no){
                x2 += 1;
            }
            else if(board[i][s-i] != -1){
                y2 += 1;
            }
        }
        
        if(x1 == s || y1 == s){
            for i in 0...size-1 {
                if(board[i][i] == -1){
                    board[i][i] = no;
                    return board;
                }
            }
        }
        
        if(x2 == s || y2 == s){
            for i in 0...size-1 {
                if(board[i][s-i] == -1){
                    board[i][s-i] = no;
                    return board;
                }
            }
        }
        
        
        var arr = [[Int]]();
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(board[i][j] == -1){
                    arr.append([i, j]);
                }
            }
        }
        
        let ct = arr.count
        if(ct <= size * size){
            let x = Int.random(in: 1...ct);
            let wi = arr[x - 1][0]
            let ko = arr[x - 1][1]
            
            board[wi][ko] = no;
        }
        
        return board;
    }
}

class HardAIPlayer : Player{
    private var sign = "x";
    
    override init(_ sign: String){
        self.sign = sign;
        super.init(sign);
    }
    
    private func countPosMoves(_ board: [[Int]], _ size: Int, _ no: Int) -> Int{
        var suma = 0;
        
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(board[i][j] != no && board[i][j] != -1){
                    suma -= 1;
                    break;
                }
            }
        }
        suma += size;
        
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(board[j][i] != no && board[j][i] != -1){
                    suma -= 1;
                    break;
                }
            }
            suma += size;
        }
        
        for i in 0...size-1 {
            if(board[i][i] != no && board[i][i] != -1){
                suma -= 1;
                break;
            }
        }
        
        let s = size - 1;
        
        for i in 0...size-1 {
            if(board[i][s-i] != no && board[i][s-i] != -1){
                suma -= 1;
                break;
            }
        }
        
        suma += 2;
        
        return suma;
    }
    
    private func rateGameState(_ board: [[Int]], row: Int, col: Int, no: Int, size: Int) -> Int{
        var tmpBoard = board;
        tmpBoard[row][col] = no;
        
        let player = countPosMoves(tmpBoard, size, no);
        var opponent = 0;
        if(no == 0){
            opponent = countPosMoves(tmpBoard, size, 1);
        }
        else{
            opponent = countPosMoves(tmpBoard, size, 0);
        }
        
        return player - opponent;
    }
    
    override func move(_ b: [[Int]], _ no: Int, _ size: Int) -> [[Int]]{
        var board = b;
        print("Aktualny gracz: ", terminator:"");
        print(self.sign);
        
        for i in 0...size-1 {
            var x1 = 0;
            var y1 = 0;
            var x2 = 0;
            var y2 = 0;
            
            for j in 0...size-1{
                if(board[i][j] == no){
                    x1 += 1;
                } 
                else if(board[i][j] != -1){
                    y1 += 1;
                }
                
                if(board[j][i] == no) {
                    x2 += 1;
                }
                else if(board[j][i] != -1){
                    y2 += 1;
                }
            }
            
            if(x1 == size-1 || y1 == size-1){
                for j in 0...size-1 {
                    if(board[i][j] == -1){
                        board[i][j] = no;
                        return board;
                    }
                }
            }
                
            if(x2 == size-1 || y2 == size-1){
                for j in 0...size-1 {
                    if(board[j][i] == -1){
                        board[j][i] = no;
                        return board;
                    }
                }
            }
        }
        
        var x1 = 0;
        var y1 = 0;
        var x2 = 0;
        var y2 = 0;
        let s = size-1;
            
        for i in 0...s{
                
            if(board[i][i] == no){
                x1 += 1;
            }
            else if(board[i][i] != -1){
                y1 += 1;
            }
                
            if(board[i][s-i] == no){
                x2 += 1;
            }
            else if(board[i][s-i] != -1){
                y2 += 1;
            }
        }
        
        if(x1 == s || y1 == s){
            for i in 0...size-1 {
                if(board[i][i] == -1){
                    board[i][i] = no;
                    return board;
                }
            }
        }
        
        if(x2 == s || y2 == s){
            for i in 0...size-1 {
                if(board[i][s-i] == -1){
                    board[i][s-i] = no;
                    return board;
                }
            }
        }
        
        
        if(board[size / 2][size / 2] == -1){
            board[size / 2][size / 2] = no;
            return board;
        }
        
        var arr = [[Int]]();
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(board[i][j] == -1){
                    arr.append([i, j]);
                }
            }
        }
        
        let ct = arr.count - 1;
        var bmIndex = 0; // best move index
        var bmRating = -100; // best move rating
        for i in 0...ct{
            let pom = rateGameState(board, row: arr[i][0], col: arr[i][1], no: no , size: size);
            if(pom > bmRating){
                bmRating = pom;
                bmIndex = i;
            }
        }
        
        let ro = arr[bmIndex][0];
        let co = arr[bmIndex][1];
        board[ro][co] = no;
        
        return board;
    }
}

print("Podaj rozmiar planszy (N x N) : ", terminator: "");
var sz = readLine();
var size:Int? = Int(sz!);
if(size! < 3){
    print("Plansza musi mieć rozmiar przynajmniej 3x3");
    print("Rozmiar został ustawiony na 3x3");
    size? = 3;
}

var g = Game(size!);
g.addPlayer(UserPlayer("o"));

while(true){
    print("Czy przeciwnikiem ma być komputer? (T/N)? - ", terminator: "");
    let aio = readLine();
    let opponent = aio!;
    
    if(opponent == "T"){
        while(true){
            print("Wybierz poziom (E - Easy / M - Medium / H - Hard) - ", terminator: "")
            let lvl = readLine();
            
            if(lvl == "E"){
                g.addPlayer(EasyAIPlayer("x"));
                break;
            }
            else if(lvl == "M"){
                g.addPlayer(MediumAIPlayer("x"));
                break;
            }
            else if(lvl == "H"){
                g.addPlayer(HardAIPlayer("x"));
                break;
            }
        }
    
        print("Gracz 1 - o")
        print("Gracz 2 (AI) - x")
        break;
    }
    else if(opponent == "N"){
        g.addPlayer(UserPlayer("x"));
        print("Gracz 1 - o")
        print("Gracz 2 - x")
        break;
    }
    else{
        print("Nieprawidłowy wybór. Spróbuj ponownie.");
    }
}

g.start();
