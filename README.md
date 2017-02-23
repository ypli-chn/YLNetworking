文章见[RAC+MVVM实践](http://blog.ypli.xyz/ios/rac-mvvmshi-jian-chu-tan-racyou-hua-wang-luo-ceng)



主要功能：

1. 基于AFNetworking封装网络层（底层网络库可以很方便的在YLAPIProxy中替换），业务使用方更加灵活、方便
2. 单独实现翻页APIManager，方便Feed类请求
3. 支持RAC
4. 支持网络请求依赖关系
5. 支持无缝刷新Token
6. 支持POST/GET缓存（请求时可选是否缓存、可配置缓存存活时间）



另外 YLAPIManagerResponseStatus 可根据项目中的状态码重新定义

PS：因为是此网络库是从实际项目中剥离出来的，所以可能部分业务代码未剥离干净，如有疑问或bug欢迎提issue



## License

YLNetworking is released under the MIT license. See [LICENSE](./LICENSE) for details.
