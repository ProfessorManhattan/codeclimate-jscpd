## Configuring jscpd

In **[Megabyte Labs](https://megabyte.space)** projects, we store our `jscpd` configuration in the `package.json` file. To accomodate this configuration location, we included the ability to specify the location of the configuration in the `.codeclimate.yml` file. Here is an example of configuring the CodeClimate engine to look in the `package.json` file for the configuration:

### Sample CodeClimate Configuration

```yaml
---
engines:
  jscpd:
    enabled: true
    options:
      config: package.json
```
