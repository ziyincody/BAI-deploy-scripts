pragma solidity >=0.6.7;

import "ds-test/test.sol";

import "./H20ProxyRegistry.sol";

contract H20ProxyRegistryTest is DSTest {
    H20ProxyRegistry registry;
    DSProxyFactory factory;

    function setUp() public {
        factory = new DSProxyFactory();
        registry = new H20ProxyRegistry(address(factory));
    }

    function test_geb_proxy_registry_build() public {
		address payable proxyAddr = registry.build();
		assertTrue(proxyAddr != address(0));
		DSProxy proxy = DSProxy(proxyAddr);

		uint codeSize;
		assembly {
			codeSize := extcodesize(proxyAddr)
		}
		//verify proxy was deployed successfully
		assertTrue(codeSize > 0);

		//verify proxy creation was logged
		assertTrue(factory.isProxy(proxyAddr));

		//verify proxy ownership
		assertEq(proxy.owner(), address(this));

		assertEq(address(registry.proxies(address(this))), proxyAddr);
	}

	function test_geb_proxy_registry_build_other_owner() public {
		address owner = address(0x123);
		address payable proxyAddr = registry.build(owner);
		assertTrue(proxyAddr != address(0));
		DSProxy proxy = DSProxy(proxyAddr);

		uint codeSize;
		assembly {
			codeSize := extcodesize(proxyAddr)
		}
		//verify proxy was deployed successfully
		assertTrue(codeSize > 0);

		//verify proxy creation was logged
		assertTrue(factory.isProxy(proxyAddr));

		//verify proxy ownership
		assertEq(proxy.owner(), owner);

		assertEq(address(registry.proxies(owner)), address(proxy));
	}

	function test_geb_proxy_registry_create_new_proxy() public {
		address payable proxyAddr = registry.build();
		assertTrue(proxyAddr != address(0));
		assertEq(proxyAddr, address(registry.proxies(address(this))));
		DSProxy(proxyAddr).setOwner(address(0));
		address payable proxyAddr2 = registry.build();
		assertTrue(proxyAddr != proxyAddr2);
		assertEq(proxyAddr2, address(registry.proxies(address(this))));
	}

	function testFail_geb_proxy_registry_create_new_proxy() public {
		registry.build();
		registry.build();
	}

	function testFail_geb_proxy_registry_create_new_proxy2() public {
		address owner = address(0x123);
		registry.build(owner);
		registry.build(owner);
	}
}
