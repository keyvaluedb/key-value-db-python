# {::nomarkdown}<p style="text-align: center;" align="center"><img src="https://github.com/konfiger/konfiger.github.io/raw/master/icons/konfiger-java.png" alt="konfiger-jvm" style="width:180px;height:160px;" width="180" height="160" /><br /> konfiger-java</p>{:/}

<p style="text-align: center;" align="center">Light weight package to manage key value based configuration and data files.</p>

---

The notable use cases of this package is loading configuration file, language file, preference setting in an application. 

___

## Table of content
- [Installation](#installation)
    - [Maven](#maven)
    - [Gradle](#gradle)
- [Examples](#examples)
    - [Basic](#basic)
    - [Write to disk](#write-to-disk)
    - [Get Types](#get-types)
    - [Lazy Loading](#lazy-loading)
    - [Seperator and delimeter](#seperator-and-delimeter)
    - [Read file with Stream](#read-file-with-stream)
    - [Read String with Stream](#read-string-with-stream)
- [Usage](#usage)
	- [Initialization](#initialization)
	- [Inserting](#inserting)
	- [Finding](#finding)
	- [Updating](#updating)
	- [Removing](#removing)
    - [Saving to disk](#saving-to-disk)
- [API Documentations](#api-documentations)
    - [KonfigerStream](#konfigerstream)
    - [Konfiger](#konfiger)
        - [Fields](#fields)
        - [Functions](#functions)
- [How it works](#how-it-works)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

## Installation

Install the package from the Python package index or download the zip and .egg file from [releases](https://github.com/keyvaluedb/key-value-db-python/releases).

```bash
pip install konfiger
```

## Examples

### Basic

The following example load from file, add an entry, remove an entry and iterate all the key value entries

```java
import io.github.thecarisma.*;
import java.io.*;
import java.util.Map;

public class Test {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        Konfiger konfiger = new Konfiger(new File("test/test.config.ini"), true);

        //add a string
        konfiger.putString("Greet", "Hello World");

        //get an object
        System.out.println(konfiger.get("Greet"));

        //remove an object
        konfiger.remove("Greet");

        //add an String
        konfiger.putString("What", "i don't know what to write here");

        for (Map.Entry<String, String> entry : konfiger.entries()) {
            System.out.println(entry);
        }
    }
}
```

### Write to disk

Initialize an empty konfiger object and populate it with random data, then save it to a file

```java
import io.github.thecarisma.*;
import java.io.*;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        String[] randomValues = { "One", "Two", "Three", "Four", "Five" };
        Konfiger konfiger = new Konfiger("", false);

        for (int i = 0; i < 200; ++i) {
            double random = Math.floor(Math.random() * (randomValues.length - 1) + 0);
            konfiger.putString(""+i, randomValues[(int)random]);
        }
        konfiger.save("test/konfiger.conf");
    }
}
```

### Get Types

Load the entries as string and get them as a true type.

```java
import io.github.thecarisma.*;
import java.io.*;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        Konfiger konfiger = new Konfiger("\n" +
                "String=This is a string\n" +
                "Number=215415245\n" +
                "Float=56556.436746\n" +
                "Boolean=true\n", false);

        String str = konfiger.getString("String");
        Long num = konfiger.getLong("Number");
        Float flo = konfiger.getFloat("Float");
        Boolean bool = konfiger.getBoolean("Boolean");

        System.out.println(str instanceof String);
        System.out.println(num instanceof Long);
        System.out.println(flo instanceof Float);
        System.out.println(bool instanceof Boolean);
    }
}
```

### Lazy Loading

The lazyLoad parameter is useful for progressively read entries from a large file. The next example shows initializing from a file with so much key value entry with lazy loading:

The content of `test/konfiger.conf` is 

```
Ones=11111111111
Twos=2222222222222
Threes=3333333333333
Fours=444444444444
Fives=5555555555555
```

```java
import io.github.thecarisma.*;
import java.io.*;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        Konfiger konfiger = new Konfiger(new File("test/konfiger.conf"), //the file path
                                true //lazyLoad true
                                );
        //at this point nothing is read from the file

        //the size of konfiger is 0 even if the file contains over 1000 entries
        System.out.println(konfiger.size());

        //the key 'Twos' is at the second line in the file, therefore two entry has 
        //been read to get the value.
        System.out.println(konfiger.get("Twos"));
        
        //the size becomes 2, 
        System.out.println(konfiger.size());
        
        //to read all the entries simply call the toString() method
        System.out.println(konfiger.toString());
        
        //now the size is equal to the entry
        System.out.println(konfiger.size());
    }
}
```

### Seperator and delimeter

Initailize a konfiger object with default seperator and delimeter then change the seperator and selimeter at runtime

```java
import io.github.thecarisma.*;
import java.io.*;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        Konfiger konfiger = new Konfiger(new File("test/konfiger.conf"), false);
        konfiger.setDelimeter('?');
        konfiger.setSeperator(',');

        System.out.println(konfiger.toString());
    }
}
```

### Read file with Stream

Read a key value file using the progressive [KonfigerStream](https://github.com/konfiger/konfiger-nodejs/blob/master/src/io/github/thecarisma/KonfigerStream.js), each scan returns the current key value array `[ 'key', 'value']`

```java
import io.github.thecarisma.*;
import java.io.*;
import java.util.Arrays;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        KonfigerStream kStream = new KonfigerStream(new File("test/konfiger.conf"));
        while (kStream.hasNext()) {
            String[] entry = kStream.next();
            System.out.println(Arrays.toString(entry));
        }
    }
}
```

### Read String with Stream

Read a key value string using the progressive [KonfigerStream](https://github.com/konfiger/konfiger-nodejs/blob/master/src/io/github/thecarisma/KonfigerStream.js), each scan returns the current key value array `[ 'key', 'value']`

```java
import io.github.thecarisma.*;
import java.io.*;
import java.util.Arrays;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        KonfigerStream kStream = new KonfigerStream("\n" +
                "String=This is a string\n" +
                "Number=215415245\n" +
                "Float=56556.436746\n" +
                "Boolean=true\n");

        while (kStream.hasNext()) {
            String[] entry = kStream.next();
            System.out.println(Arrays.toString(entry));
        }
    }
}
```

### Skip Comment entries

Read all the key value entry using the stream and skipping all commented entries. The default comment prefix is `//` but in the example below the commented entries starts with `#` so the prefix is changed. The same thing happen if the key value entry is loaded from file. 

```java
import io.github.thecarisma.*;
import java.io.*;
import java.util.Arrays;

public class Test_Java {
    public static void main(String[] args) throws IOException, InvalidEntryException {
        KonfigerStream kStream = new KonfigerStream("\n" +
                "String=This is a string\n" +
                "#Number=215415245\n" +
                "Float=56556.436746\n" +
                "#Boolean=true\n");
        kStream.setCommentPrefix("#");
        
        while (kStream.hasNext()) {
            String[] entry = kStream.next();
            System.out.println(Arrays.toString(entry));
        }
    }
}
```

## Usage

### Initialization

The main Konfiger contructor is not exported from the package, the two functions are exported for initialization, `fromString` and `fromFile`. The fromString function creates a Konfiger object from a string with valid key value entry or from empty string, the fromFile function creates the Konfiger object from a file, the two functions accept a cumpulsory second parameter `lazyLoad` which indicates whether to read all the entry from the file or string suring initialization. The lazyLoad parameter is useful for progressively read entries from a large file. The two initializing functions also take 2 extra optional parameters `delimeter` and `seperator`. If the third and fourth parameter is not specified the default is used, delimeter = `=`, seperator = `\n`. If the file or string has different delimeter and seperator always send the third and fourth parameter.

The following initializer progressively read the file when needed

```java
Konfiger konfiger = new Konfiger(new File("test/konfiger.conf"), true);
```

The following initializer read all the entries from file at once

```java
Konfiger konfiger = new Konfiger(new File("test/konfiger.conf"), false);
```

The following initializer read all the entries from string when needed

```java
Konfiger konfiger = new Konfiger("\n" +
                "Ones=11111111111\n" +
                "Twos=2222222222222\n", true);
```

The following initializer read all the entries from String at once

```java
Konfiger konfiger = new Konfiger("\n" +
                "Ones=11111111111\n" +
                "Twos=2222222222222\n", true);
```

Initialize a string which have custom delimeter and seperator

```java
Konfiger konfiger = new Konfiger("Ones:11111111111,Twos:2222222222222",
                true,
                ':',
                ',');
```

### Inserting

The following types can be added into the object, int, float, long, boolean, object and string.

To add any object into the entry use the `put` method as it check the value type and properly get it string value

```java
konfiger.put("String", "This is a string");
konfiger.put("Long", 143431423);
konfiger.put("Boolean", true);
konfiger.put("Float", 12.345);
```

The `put` method do a type check on the value and calls the appropriate put method e.g `konfiger.put("Boolean", true)` will result in a call to `konfiger.putBoolean("Boolean", true)`. The following method are avaliable to directly add the value according to the type, `putString`, `putBoolean`, `putLong` and `putInt`. The previous example can be re-written as:

```java
konfiger.putString("String", "This is a string");
konfiger.putLong("Long", 143431423);
konfiger.putBoolean("Boolean", true);
konfiger.putFloat("Float", 12.345F);
```

### Finding

There are various ways to get the value from the konfiger object, the main `get` method and `getString` method both returns a string type, the other get methods returns specific types

```java
konfiger.get("String");
```

To get specific type from the object use the following methods, `getString`, `getBoolean`, `getLong`, `getFloat` and `getInt`. 

```java
konfiger.getString("String");
konfiger.getLong("Long");
konfiger.getBoolean("Boolean");
konfiger.getFloat("Float");
```

If the requested entrr does not exist a null/undefined value is returned, to prevent that a fallback value should be sent as second parameter incase the key is not found the second parameter will be returned.

```java
konfiger.get("String", "Default Value");
konfiger.getBoolean("Boolean", false);
```

If the konfiger is initialized with lazy loading enabled if the get method is called the stream will start reading until the key is found and the stream is paused again, if the key is not found the stream will read to end. 

### Updating

The `put` method can be used to add new entry or to update an already existing entry in the object. The `updateAt` method is usefull for updating a value using it index instead of key

```java
konfiger.updateAt(0, "This is an updated string");
```

### Removing

The `remove` method removes a key value entry from the konfiger, it returns true if an entry is removed and false if no entry is removed. The `remove` method accept either key(string) or index(int) of the entry.

```java
konfiger.remove("String");
konfiger.remove(0);
```

### Saving to disk

Every operation on the konfiger object is done in memory to save the updated entries in a file call the `save` method with the file path to save the entry. If the konfiger is initiated from file then there is no need to add the file path to the `save` method, the entries will be saved to the file path used during initialization.

```java
konfiger.save("test/test.config.ini");
```

in case of load from file, the save will write the entries to *test/test.config.ini*.

```java
//...
Konfiger konfiger = new Konfiger(new File("test/test.config.ini"), true);
//...
konfiger.save();
```

## API Documentations

### KonfigerStream

| Function        | Description         
| --------------- | ------------- 
| public KonfigerStream(File file, char delimeter, char seperator, boolean errTolerance) throws FileNotFoundException  | Initialize a new KonfigerStream object from the filePath. It throws en exception if the filePath does not exist or if the delimeter or seperator is not a single character. The last parameter is boolean if true the stream is error tolerant and does not throw any exception on invalid entry, only the first parameter is cumpulsory.
| public KonfigerStream(String rawString, char delimeter, char seperator, boolean errTolerance)  | Initialize a new KonfigerStream object from a string. It throws en exception if the rawString is not a string or if the delimeter or seperator is not a single character. The last parameter is boolean if true the stream is error tolerant and does not throw any exception on invalid entry, only the first parameter is cumpulsory.
| public boolean hasNext() throws IOException  | Check if the KonfigerStream still has a key value entry, returns true if there is still entry, returns false if there is no more entry in the KonfigerStream
| public String[] next() throws InvalidEntryException, IOException  | Get the next Key Value array from the KonfigerStream is it still has an entry. Throws an error if there is no more entry. Always use `hasNext()` to check if there is still an entry in the stream.
| public boolean isTrimming() | Check if the stream is configured to trim key
| public void setTrimming(boolean trimming) | Change the stream to enable/disable key trimming
| public String getCommentPrefix() | Get the prefix string that indicate a pair entry if commented
| public void setCommentPrefix(String commentPrefix) | Change the stream comment prefix, any entry starting with the comment prefix will be skipped. Comment in KonfigerStream is relative to the key value entry and not relative to a line.

### Konfiger

#### Fields

| Field        | Description         
| --------------- | ------------- 
| MAX_CAPACITY  | The number of datas the konfiger can take, 10000000

#### Functions

| Function        | Description         
| --------------- | ------------- 
| public Konfiger(File file, boolean lazyLoad) throws IOException, InvalidEntryException  | Create the konfiger object from a file, the first parameter(string) is the file path, the second parameter(boolean) indicates whether to read all the entry in the file in the constructor or when needed, the default delimeter(`=`) and seperator(`\n`) will be used. This creates the konfiger object from call to `fromStream(konfigerStream, lazyLoad)` with the konfigerStream initialized with the filePath parameter. The new Konfiger object is returned.
| public Konfiger(File file, boolean lazyLoad, char delimeter, char seperator) throws IOException, InvalidEntryException  | Create the konfiger object from a file, the first(string) parameter is the file path, the second parameter(boolean) indicates whether to read all the entry in the file in the constructor or when needed, the third param(char) is the delimeter and the fourth param(char) is the seperator. This creates the konfiger object from call to `fromStream(konfigerStream, lazyLoad)` with the konfigerStream initialized with the filePath parameter. The new Konfiger object is returned.
| public Konfiger(String rawString, boolean lazyLoad) throws IOException, InvalidEntryException | Create the konfiger object from a string, the first parameter is the String(can be empty), the second boolean parameter indicates whether to read all the entry in the file in the constructor or when needed, the default delimeter(`=`) and seperator(`\n`) will be used. The new Konfiger object is returned.
| public Konfiger(String rawString, boolean lazyLoad, char delimeter, char seperator) throws IOException, InvalidEntryException  | Create the konfiger object from a string, the first parameter is the String(can be empty), the second boolean parameter indicates whether to read all the entry in the file in the constructor or when needed, the third param is the delimeter and the fourth param is the seperator. The new Konfiger object is returned.
| public Konfiger(KonfigerStream konfigerStream, boolean lazyLoad)  | Create the konfiger object from a KonfigerStream object, the second boolean parameter indicates whether to read all the entry in the file in the constructor or when needed this make data loading progressive as data is only loaded from the file when put or get until the Stream reaches EOF. The new Konfiger object is returned.
| public void put(String key, Object value)           | Put any object into the konfiger. if the second parameter is a Javascript Object, `JSON.stringify` will be used to get the string value of the object else the appropriate put* method will be called. e.g `put('Name', 'Adewale')` will result in the call `putString('Name', 'Adewale')`.
| public void putString(String key, String value)           | Put a String into the konfiger, the second parameter must be a string.
| public void putBoolean(String key, boolean value)           | Put a Boolean into the konfiger, the second parameter must be a Boolean.
| public void putLong(String key, long value)           | Put a Long into the konfiger, the second parameter must be a Number.
| public void putInt(String key, int value)           | Put a Int into the konfiger, alias for `public void putLong(String key, long value)`.
| public void putFloat(String key, float value)           | Put a Float into the konfiger, the second parameter must be a Float
| public void putDouble(String key, double value)           | Put a Double into the konfiger, the second parameter must be a Double
| public Set<String> keys()           | Get all the keys entries in the konfiger object in iterable array list
| public Collection<String> values()           | Get all the values entries in the konfiger object in iterable array list
| public Set<Map.Entry<String, String>> entries()           | Get all the entries in the konfiger in a `Set<Map.Entry<String, String>>`
| public Object get(String key, Object fallbackValue)        | Get a value as string, the second parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified `null` will be returned
| public String getString(String key, String fallbackValue)   | Get a value as string, the second(string) parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified empty string will be returned. 
| public boolean getBoolean(String key, boolean fallbackValue)   | Get a value as boolean, the second(Boolean) parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified `false` will be returned. When trying to cast the value to boolean if an error occur an exception will be thrown except if error tolerance is set to true then false will be returned. use `errorTolerance(Boolean)` to set the konfiger object error tolerancy.
| public long getLong(String key, long fallbackValue)   | Get a value as Number, the second(Number) parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified `0` will be returned. When trying to cast the value to Number if an error occur an exception will be thrown except if error tolerance is set to true then `0` will be returned. use `errorTolerance(Boolean)` to set the konfiger object error tolerancy.
| public int getInt(String key, int fallbackValue)   | Get a value as Number.
| public float getFloat(String key, float fallbackValue)   | Get a value as Float, the second(Float) parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified `0.0` will be returned. When trying to cast the value to Float if an error occur an exception will be thrown except if error tolerance is set to true then `0.0` will be returned. use `errorTolerance(Boolean)` to set the konfiger object error tolerancy.
| public double getDouble(String key, double fallbackValue)   | Get a value as Double, the second(Double) parameter is optional if it is specified it is returned if the key does not exist, if the second parameter is not specified `0.0` will be returned. When trying to cast the value to Double if an error occur an exception will be thrown except if error tolerance is set to true then `0.0` will be returned. use `errorTolerance(Boolean)` to set the konfiger object error tolerancy.
| public String remove(int index)           | Remove a key value entry at a particular index. Returns the value of the entry that was removed.
| public String remove(String key)           | Remove a key value entry using the entry Key. Returns the value of the entry that was removed.
| public void appendString(String rawString) throws IOException, InvalidEntryException          | Append new data to the konfiger from a string, the new string delimeter and seperator must be the same with the current konfigure delimeter and seperator, if it not the same use the `setDelimeter` and `setSeperator` to change the konfiger seperator and delimeter to the new file seperator and delimeter. If the Konfiger is initialized with lazy loading all the data will be loaded before the entries from the new string is added.
| public void appendFile(File file) throws IOException, InvalidEntryException          | Read new datas from the file path and append, the new file delimeter and seperator must be the same with the current konfigure delimeter and seperator, if it not the same use the `setDelimeter` and `setSeperator` to change the konfiger seperator and delimeter to the new file seperator and delimeter. If the Konfiger is initialized with lazy loading all the data will be loaded before the entries from the new string is added.
| public void appendString(String rawString, char delimeter, char seperator) throws IOException, InvalidEntryException          | Append new data to the konfiger from a string. If the Konfiger is initialized with lazy loading all the data will be loaded before the entries from the new string is added.
| public void appendFile(File file, char delimeter, char seperator) throws IOException, InvalidEntryException          | Read new datas from the file path and append. If the Konfiger is initialized with lazy loading all the data will be loaded before the entries from the new string is added.
| public void save() throws FileNotFoundException, public void save(String filePath) throws FileNotFoundException         | Save the konfiger datas into a file. The argument filePath is optional if specified the entries is writtent to the filePath else the filePath used to initialize the Konfiger object is used and if the Konfiger is initialized `fromString` and the filePath is not specified an exception is thrown. This does not clear the already added entries.
| public char getSeperator()           | Get seperator char that seperate the key value entry, default is `\n`.
| public char getDelimeter()           | Get delimeter char that seperated the key from it value, default is `=`.
| public void setSeperator(char seperator)           | Change seperator char that seperate the datas, note that the file is not updates, to change the file call the `save()` function. If the new seperator is different from the old one all the entries values will be re parsed to get the new proper values, this process can take time if the entries is much.
| public void setDelimeter(char delimeter)           | Change delimeter char that seperated the key from object, note that the file is not updates, to change the file call the `save()` function 
| public int size()           | Get the total size of key value entries in the konfiger
| public void clear()           | clear all the key value entries in the konfiger. This does not update the file call the `save` method to update the file
| public boolean isEmpty()           | Check if the konfiger does not have an key value entry.
| public void updateAt(int index, String value)           | Update the value at the specified index with the new string value, throws an error if the index is OutOfRange 
| public boolean contains(String key)           | Check if the konfiger contains a key 
| public void enableCache(boolean enableCache_)           | Enable or disable caching, caching speeds up data search but can take up space in memory (very small though). Using `getString` method to fetch vallue **99999999999** times with cache disabled takes over 1hr and with cache enabled takes 20min.
| public void errorTolerance(boolean errTolerance)           | Enable or disable the error tolerancy property of the konfiger, if enabled no exception will be throw even when it suppose to there for it a bad idea but useful in a fail safe environment.
| public boolean isErrorTolerant() | Check if the konfiger object errTolerance is set to true.
| @Override public String toString()           | All the kofiger datas are parsed into valid string with regards to the delimeter and seprator, the result of this method is what get written to file in the `save` method. The result is cached and calling the method while the no entry is added, deleted or updated just return the last result instead of parsing the entries again.

## How it works

Konfiger stream progressively load the key value entry from a file or string when needed, it uses two method `hasNext` which check if there is still an entry in the stream and `next` for the current key value entry in the stream. 
 
In Konfiger the key value pair is stored in a `map`, all search updating and removal is done on the `konfigerObjects` in the class. The string sent as first parameter if parsed into valid key value using the separator and delimiter fields and if loaded from file it content is parsed into valid key value pair. The `toString` method also parse the `konfigerObjects` content into a valid string with regards to the 
separator and delimeter. The value is properly escaped and unescaped.

The `save` function write the current `Konfiger` to the file, if the file does not exist it is created if it can. Everything is written in memory and is disposed on app exit hence it important to call the `save` function when nessasary.

## Contributing

Before you begin contribution please read the contribution guide at [CONTRIBUTING GUIDE](https://github.com/konfiger/konfiger.github.io/blob/master/CONTRIBUTING.MD)

You can open issue or file a request that only address problems in this implementation on this repo, if the issue address the concepts of the package then create an issue or rfc [here](https://github.com/konfiger/konfiger.github.io/)

## Support

You can support some of this community as they make big impact in the traing of individual to get started with software engineering and open source contribution.

- [https://www.patreon.com/devcareer](https://www.patreon.com/devcareer)

## License

MIT License Copyright (c) 2020 [Adewale Azeez](https://twitter.com/iamthecarisma) - konfiger

